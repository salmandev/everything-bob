---
name: error-boundary-patterns
description: >-
  Use when the user wants to add error handling to a React app, implement React error boundaries, handle async errors gracefully, create fallback UIs for failed components, or set up global error tracking with Sentry or similar.
---

# Error Boundary Patterns

Implement comprehensive error handling in React — catch crashes gracefully and track them.

## Step 1 — React Error Boundary (Class Component)
```tsx
import React, { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
  onError?: (error: Error, info: React.ErrorInfo) => void;
}

interface State { hasError: boolean; error: Error | null; }

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    console.error('Uncaught error:', error, info);
    this.props.onError?.(error, info);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback ?? (
        <div role="alert">
          <h2>Something went wrong.</h2>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try again
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
```

## Step 2 — react-error-boundary (Modern Hook-Friendly)
```bash
npm install react-error-boundary
```
```tsx
import { ErrorBoundary, useErrorBoundary } from 'react-error-boundary';

function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert">
      <p>Something went wrong:</p>
      <pre style={{ color: 'red' }}>{error.message}</pre>
      <button onClick={resetErrorBoundary}>Try again</button>
    </div>
  );
}

// Usage
<ErrorBoundary FallbackComponent={ErrorFallback} onReset={() => refetch()}>
  <DataComponent />
</ErrorBoundary>

// Throw from async code into nearest boundary
function DataComponent() {
  const { showBoundary } = useErrorBoundary();
  useEffect(() => {
    fetchData().catch(showBoundary);
  }, []);
}
```

## Step 3 — Global Error Tracking with Sentry
```bash
npm install @sentry/nextjs  # or @sentry/react, @sentry/node
```
```typescript
// sentry.client.config.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
  beforeSend(event) {
    // Scrub PII before sending
    if (event.user) delete event.user.email;
    return event;
  },
});
```

## Step 4 — Async Error Handling Patterns
```typescript
// Result type — explicit error handling without try/catch noise
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await db.user.findUniqueOrThrow({ where: { id } });
    return { ok: true, value: user };
  } catch (error) {
    return { ok: false, error: error as Error };
  }
}

// Usage — forced error handling at call site
const result = await fetchUser(userId);
if (!result.ok) {
  logger.error({ err: result.error }, 'Failed to fetch user');
  return res.status(404).json({ error: 'User not found' });
}
const user = result.value;
```

## Step 5 — Error Boundary Placement Strategy
```
App
├── <ErrorBoundary> — catches catastrophic failures
│   ├── <Navbar />
│   ├── <ErrorBoundary> — catches route-level errors
│   │   └── <PageContent />
│   └── <ErrorBoundary> — catches widget errors (doesn't crash page)
│       └── <DataWidget />
```

Rule: Each independently deployable unit of UI should have its own boundary.

## Verification Checklist
- [ ] Error boundaries placed at route and widget level (not just root)
- [ ] Sentry (or equivalent) initialized and receiving events
- [ ] PII scrubbed before sending error events externally
- [ ] `resetErrorBoundary` wired to data-refetch where appropriate
- [ ] All unhandled promise rejections logged at the process level
