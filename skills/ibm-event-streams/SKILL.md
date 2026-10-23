---
name: ibm-event-streams
description: >-
  Use when the user wants to use IBM Event Streams (managed Kafka on IBM Cloud), produce or consume Kafka messages, design Kafka topic architecture, configure consumer groups, handle message ordering, or connect Event Streams to a Node.js or Python application.
---

# IBM Event Streams (Managed Kafka)

Build event-driven applications with IBM Event Streams — IBM Cloud's managed Apache Kafka service.

## Step 1 — Get Connection Credentials
```bash
# Create Event Streams instance and service key
ibmcloud resource service-instance-create my-event-streams messagehub standard us-south
ibmcloud resource service-key-create my-event-streams-key Manager \
  --instance-name my-event-streams

# Extract credentials
ibmcloud resource service-key my-event-streams-key --output json | \
  jq '.credentials' > event-streams-credentials.json
```

## Step 2 — Produce Messages (Node.js with KafkaJS)
```typescript
import { Kafka, CompressionTypes } from 'kafkajs';

const kafka = new Kafka({
  clientId: 'my-producer',
  brokers: process.env.KAFKA_BROKERS!.split(','),
  ssl: true,
  sasl: {
    mechanism: 'plain',
    username: 'token',
    password: process.env.KAFKA_API_KEY!,
  },
});

const producer = kafka.producer({
  idempotent: true,                    // Exactly-once delivery
  transactionTimeout: 30000,
});

await producer.connect();

await producer.send({
  topic: 'orders',
  compression: CompressionTypes.GZIP,
  messages: [
    {
      key: orderId,                    // Use entity ID as key for ordering
      value: JSON.stringify({ orderId, userId, amount, status: 'CREATED' }),
      headers: { 'content-type': 'application/json', source: 'order-service' },
    },
  ],
});

await producer.disconnect();
```

## Step 3 — Consume Messages (Node.js)
```typescript
const consumer = kafka.consumer({
  groupId: 'order-processor-v1',     // Version your consumer group IDs
});

await consumer.connect();
await consumer.subscribe({ topic: 'orders', fromBeginning: false });

await consumer.run({
  eachMessage: async ({ topic, partition, message }) => {
    const event = JSON.parse(message.value!.toString());

    try {
      await processOrder(event);
      // Commit happens automatically after eachMessage resolves
    } catch (err) {
      // Log and dead-letter on permanent errors
      await producer.send({
        topic: 'orders.dead-letter',
        messages: [{ key: message.key, value: message.value, headers: {
          'original-topic': topic,
          'error': String(err),
        }}],
      });
    }
  },
});
```

## Step 4 — Topic Design Best Practices
```bash
# Create topics via IBM Event Streams Admin API
curl -X POST \
  "${EVENT_STREAMS_URL}/admin/topics" \
  -H "Authorization: Bearer ${KAFKA_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "orders",
    "partitions": 6,
    "configs": {
      "retentionMs": "604800000",
      "cleanupPolicy": "delete"
    }
  }'
```

Topic naming convention: `<domain>.<entity>.<event-type>`
Examples: `orders.order.created`, `payments.payment.failed`, `users.user.deleted`

Partitions: Use entity ID as message key to guarantee ordering per entity.

## Step 5 — Python Consumer (confluent-kafka)
```python
from confluent_kafka import Consumer, KafkaException
import json, os

consumer = Consumer({
    'bootstrap.servers': os.environ['KAFKA_BROKERS'],
    'security.protocol': 'SASL_SSL',
    'sasl.mechanisms': 'PLAIN',
    'sasl.username': 'token',
    'sasl.password': os.environ['KAFKA_API_KEY'],
    'group.id': 'my-consumer-group-v1',
    'auto.offset.reset': 'latest',
    'enable.auto.commit': False,   # Manual commit for reliability
})

consumer.subscribe(['orders'])

try:
    while True:
        msg = consumer.poll(timeout=1.0)
        if msg is None: continue
        if msg.error(): raise KafkaException(msg.error())

        event = json.loads(msg.value().decode('utf-8'))
        process_order(event)
        consumer.commit(message=msg)  # Commit after successful processing
finally:
    consumer.close()
```

## Verification Checklist
- [ ] API keys stored in environment variables, never in code
- [ ] Message keys set to entity IDs for per-entity ordering guarantees
- [ ] Consumer group IDs versioned (`my-consumer-v1`) — allows safe reset
- [ ] Dead-letter topic configured for poison pill messages
- [ ] `enable.auto.commit=false` in Python — manual commit after processing
