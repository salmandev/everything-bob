---
name: fullstack-nextjs
description: >-
  Use when the user is building with Next.js App Router, using React Server Components, writing Server Actions, troubleshooting hydration errors, or implementing data fetching with the App Router.
---

# Fullstack Next.js (App Router)

Build Next.js applications with App Router, RSC, and Server Actions correctly.

## Step 1 — Understand the Rendering Boundary
- **Server Components (default)**: render on server, no `useState`/`useEffect`, can `async/await` directly
- **Client Components**: add `'use client'` directive, interactive, use hooks
- Rule: Push `'use client'` as far down the tree as possible

## Step 2 — Data Fetching in Server Components
```typescript
// app/users/page.tsx — Server Component (default)
async function UsersPage() {
  const users = await db.user.findMany(); // direct DB access is fine
  return <UserList users={users} />;
}
```

## Step 3 — Server Actions for Mutations
```typescript
// app/users/actions.ts
'use server';

import { revalidatePath } from 'next/cache';

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string;
  await db.user.create({ data: { name } });
  revalidatePath('/users');
}
```

## Step 4 — Handle Hydration Errors
Common causes:
- Rendering different content on server vs. client (e.g., `new Date()`, `Math.random()`)
- Wrapping `<p>` inside `<p>`
- Missing `key` props in lists

Fix: use `suppressHydrationWarning` sparingly, or move dynamic content to a Client Component.

## Step 5 — Loading and Error States
```
app/
  users/
    page.tsx        # Server Component
    loading.tsx     # Automatic Suspense boundary
    error.tsx       # Error boundary ('use client' required)
    not-found.tsx   # 404 state
```

## Verification Checklist
- [ ] `'use client'` only where interactivity is needed
- [ ] Data fetching in Server Components, not in `useEffect`
- [ ] Server Actions used for all mutations
- [ ] `loading.tsx` and `error.tsx` present for all routes
