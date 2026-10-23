---
name: observability-engineer
description: >-
  Use when the user wants to add observability to an application, implement structured logging, set up distributed tracing with OpenTelemetry, create dashboards, configure alerts, or debug a production incident using logs and traces.
---

# Observability Engineer

Instrument applications with the three pillars: logs, metrics, and traces.

## Step 1 — Structured Logging
Never use `console.log`. Use structured JSON logging:

**Node.js with Pino:**
```typescript
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  redact: ['req.headers.authorization', 'body.password'],
});

// Usage — always log structured context
logger.info({ userId, orderId, amount }, 'payment.initiated');
logger.error({ err, userId, orderId }, 'payment.failed');
```

**Python with structlog:**
```python
import structlog

log = structlog.get_logger()
log.info("payment.initiated", user_id=user_id, order_id=order_id, amount=amount)
log.error("payment.failed", exc_info=True, user_id=user_id)
```

## Step 2 — OpenTelemetry Distributed Tracing
```typescript
// src/telemetry.ts — initialize before app starts
import { NodeSDK } from '@opentelemetry/sdk-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';
import { Resource } from '@opentelemetry/resources';
import { SEMRESATTRS_SERVICE_NAME } from '@opentelemetry/semantic-conventions';

const sdk = new NodeSDK({
  resource: new Resource({
    [SEMRESATTRS_SERVICE_NAME]: 'my-service',
  }),
  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT,
  }),
});
sdk.start();

// Manual span creation
import { trace } from '@opentelemetry/api';
const tracer = trace.getTracer('my-service');

async function processPayment(orderId: string) {
  return tracer.startActiveSpan('payment.process', async (span) => {
    span.setAttribute('order.id', orderId);
    try {
      const result = await chargeCard(orderId);
      span.setStatus({ code: SpanStatusCode.OK });
      return result;
    } catch (err) {
      span.recordException(err as Error);
      span.setStatus({ code: SpanStatusCode.ERROR });
      throw err;
    } finally {
      span.end();
    }
  });
}
```

## Step 3 — Prometheus Metrics
```typescript
import { Registry, Counter, Histogram } from 'prom-client';

const registry = new Registry();

const httpRequestsTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  registers: [registry],
});

const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.005, 0.01, 0.05, 0.1, 0.5, 1, 2, 5],
  registers: [registry],
});

// Express middleware
app.use((req, res, next) => {
  const end = httpRequestDuration.startTimer({ method: req.method, route: req.route?.path });
  res.on('finish', () => {
    httpRequestsTotal.inc({ method: req.method, route: req.route?.path, status_code: res.statusCode });
    end();
  });
  next();
});

// Expose /metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', registry.contentType);
  res.end(await registry.metrics());
});
```

## Step 4 — Alert Design (SLO-Based)
```yaml
# prometheus/alerts.yml
groups:
  - name: slo-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          rate(http_requests_total{status_code=~"5.."}[5m])
          / rate(http_requests_total[5m]) > 0.01
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Error rate above 1% SLO"

      - alert: SlowP99Latency
        expr: |
          histogram_quantile(0.99,
            rate(http_request_duration_seconds_bucket[5m])
          ) > 1.0
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P99 latency above 1 second"
```

## Step 5 — Production Incident Debugging
```bash
# Find errors in last 15 minutes
grep '"level":"error"' app.log | tail -50 | jq '.err.message' | sort | uniq -c | sort -rn

# Find slow requests
grep '"responseTime"' app.log | jq 'select(.responseTime > 1000)' | tail -20

# Correlate by trace ID
grep '"traceId":"abc123"' app.log | jq '{time:.time,msg:.msg,level:.level}'
```

## Verification Checklist
- [ ] All logs are structured JSON with consistent field names
- [ ] Sensitive fields redacted (authorization headers, passwords)
- [ ] Trace IDs propagated across service boundaries
- [ ] `/metrics` endpoint exposed and scraped by Prometheus
- [ ] Alerts defined for error rate and latency SLOs
