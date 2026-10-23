---
name: prisma-architect
description: >-
  Use when the user is working with Prisma ORM, designing a Prisma schema, writing Prisma migrations, querying with PrismaClient, optimizing Prisma queries, or using Prisma with Next.js or a Node.js API.
---

# Prisma Architect

Design Prisma schemas and queries for correctness, performance, and type safety.

## Step 1 — Schema Design
```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String    @id @default(cuid())
  email     String    @unique
  name      String
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt
  orders    Order[]
  profile   Profile?

  @@index([email])
}

model Order {
  id         String      @id @default(cuid())
  status     OrderStatus @default(PENDING)
  amount     Decimal     @db.Decimal(10, 2)
  userId     String
  user       User        @relation(fields: [userId], references: [id])
  items      OrderItem[]
  createdAt  DateTime    @default(now())

  @@index([userId, status])
  @@index([createdAt])
}

enum OrderStatus {
  PENDING
  CONFIRMED
  SHIPPED
  DELIVERED
  CANCELLED
}
```

## Step 2 — Migrations
```bash
# Create a new migration (dev)
npx prisma migrate dev --name add_order_notes

# Apply migrations in production (no prompt)
npx prisma migrate deploy

# Check migration status
npx prisma migrate status
```

## Step 3 — Querying Patterns
```typescript
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

// Paginated query with relation
const orders = await prisma.order.findMany({
  where: { userId, status: 'PENDING' },
  include: { items: { select: { productId: true, quantity: true } } },
  orderBy: { createdAt: 'desc' },
  take: 20,
  skip: page * 20,
});

// Transaction for atomic operations
const [user, order] = await prisma.$transaction([
  prisma.user.update({ where: { id: userId }, data: { updatedAt: new Date() } }),
  prisma.order.create({ data: { userId, amount: 99.99, status: 'PENDING' } }),
]);

// Upsert
const profile = await prisma.profile.upsert({
  where: { userId },
  create: { userId, bio: 'New user' },
  update: { bio: newBio },
});
```

## Step 4 — Avoid N+1 Queries
```typescript
// BAD — N+1: 1 query for orders + N queries for users
const orders = await prisma.order.findMany();
for (const order of orders) {
  const user = await prisma.user.findUnique({ where: { id: order.userId } }); // N queries!
}

// GOOD — single query with include
const orders = await prisma.order.findMany({
  include: { user: { select: { id: true, name: true, email: true } } },
});
```

## Step 5 — Prisma in Production
```typescript
// Singleton pattern — avoid exhausting connection pool
// lib/prisma.ts
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };
export const prisma = globalForPrisma.prisma ?? new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error'] : ['error'],
});
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;
```

## Verification Checklist
- [ ] `@@index` defined for all common query predicates and foreign keys
- [ ] No N+1 queries — use `include`/`select` to fetch relations in one query
- [ ] `prisma migrate deploy` used in CI/CD (not `migrate dev`)
- [ ] PrismaClient is a singleton (not instantiated per-request)
- [ ] Sensitive fields (passwords) excluded from default `select`
