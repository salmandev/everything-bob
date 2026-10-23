---
name: websocket-realtime
description: >-
  Use when the user wants to add real-time features, implement WebSockets, use Socket.io, build a live chat or notification system, implement Server-Sent Events, or handle real-time data updates in a web application.
---

# WebSocket & Real-Time

Build reliable real-time features with WebSockets, Socket.io, or Server-Sent Events.

## Step 1 — Choose the Right Technology
| Use Case | Best Choice |
| --- | --- |
| Chat, multiplayer, bidirectional | Socket.io or native WebSocket |
| Live feed, notifications, one-way | Server-Sent Events (SSE) |
| Simple broadcast with Next.js | Pusher or Ably (managed) |
| High throughput, binary data | Native WebSocket |

## Step 2 — Socket.io Server (Node.js)
```typescript
import { Server } from 'socket.io';
import { createServer } from 'http';

const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: { origin: process.env.CLIENT_URL, credentials: true },
  pingTimeout: 60000,
  pingInterval: 25000,
});

// Authentication middleware
io.use(async (socket, next) => {
  const token = socket.handshake.auth.token;
  try {
    const user = await verifyJWT(token);
    socket.data.user = user;
    next();
  } catch {
    next(new Error('Authentication failed'));
  }
});

io.on('connection', (socket) => {
  const { user } = socket.data;
  console.log(`${user.id} connected`);

  // Join user's personal room
  socket.join(`user:${user.id}`);

  socket.on('message:send', async ({ roomId, text }) => {
    const msg = await saveMessage({ userId: user.id, roomId, text });
    // Broadcast to all room members
    io.to(`room:${roomId}`).emit('message:new', msg);
  });

  socket.on('room:join', (roomId) => socket.join(`room:${roomId}`));

  socket.on('disconnect', () => console.log(`${user.id} disconnected`));
});
```

## Step 3 — Socket.io Client (React)
```typescript
import { useEffect, useRef, useState } from 'react';
import { io, Socket } from 'socket.io-client';

export function useSocket(token: string) {
  const socketRef = useRef<Socket | null>(null);

  useEffect(() => {
    socketRef.current = io(process.env.NEXT_PUBLIC_WS_URL!, {
      auth: { token },
      reconnectionAttempts: 5,
      reconnectionDelay: 1000,
    });

    socketRef.current.on('connect_error', (err) => {
      console.error('Socket connection error:', err.message);
    });

    return () => { socketRef.current?.disconnect(); };
  }, [token]);

  return socketRef.current;
}
```

## Step 4 — Server-Sent Events (Simpler Alternative)
```typescript
// Server
app.get('/events', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const send = (event: string, data: unknown) => {
    res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
  };

  const interval = setInterval(() => send('ping', { time: Date.now() }), 30000);
  req.on('close', () => clearInterval(interval));
});

// Client
const es = new EventSource('/events');
es.addEventListener('notification', (e) => setNotifications(prev => [...prev, JSON.parse(e.data)]));
```

## Step 5 — Scaling with Redis Pub/Sub
For multiple server instances, use Redis adapter:
```bash
npm install @socket.io/redis-adapter ioredis
```
```typescript
import { createAdapter } from '@socket.io/redis-adapter';
import { Redis } from 'ioredis';

const pub = new Redis(process.env.REDIS_URL!);
const sub = pub.duplicate();
io.adapter(createAdapter(pub, sub));
// Now events broadcast across all server instances
```

## Verification Checklist
- [ ] Authentication verified on WebSocket connection (not just HTTP)
- [ ] Disconnection handled gracefully with cleanup
- [ ] Rooms used for scoped broadcasts (not broadcast to all)
- [ ] Reconnection logic configured on client
- [ ] Redis adapter configured if running multiple server instances
