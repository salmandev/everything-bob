---
name: openapi-first
description: >-
  Use when the user wants to design an API spec first before writing code, generate server stubs from OpenAPI, validate requests against an OpenAPI schema, generate TypeScript types from OpenAPI, or sync a codebase with an OpenAPI contract.
---

# OpenAPI-First Development

Design the contract first, then generate the implementation. Never write routes that drift from the spec.

## Step 1 — Write the OpenAPI 3.1 Spec
```yaml
# openapi.yaml
openapi: "3.1.0"
info:
  title: My API
  version: "1.0.0"
  description: |
    API description. Include business context, not just technical details.

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: http://localhost:3000/v1
    description: Local development

paths:
  /users:
    post:
      operationId: createUser
      summary: Create a new user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreateUserRequest"
      responses:
        "201":
          description: User created
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "409":
          $ref: "#/components/responses/Conflict"
        "422":
          $ref: "#/components/responses/ValidationError"

components:
  schemas:
    CreateUserRequest:
      type: object
      required: [email, name]
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
    User:
      type: object
      required: [id, email, name, createdAt]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
        createdAt:
          type: string
          format: date-time
  responses:
    Conflict:
      description: Resource already exists
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
    ValidationError:
      description: Request validation failed
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
    ProblemDetail:
      type: object
      required: [type, title, status]
      properties:
        type:
          type: string
          format: uri
        title:
          type: string
        status:
          type: integer
        detail:
          type: string
        errors:
          type: array
          items:
            type: object
```

## Step 2 — Generate TypeScript Types
```bash
npm install --save-dev openapi-typescript
npx openapi-typescript openapi.yaml -o src/types/api.d.ts
```

```typescript
import type { paths, components } from './types/api';

type CreateUserRequest = components['schemas']['CreateUserRequest'];
type User = components['schemas']['User'];

// Fully typed fetch
async function createUser(data: CreateUserRequest): Promise<User> {
  const res = await fetch('/v1/users', {
    method: 'POST',
    body: JSON.stringify(data),
    headers: { 'Content-Type': 'application/json' },
  });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}
```

## Step 3 — Validate Requests at Runtime (Hono / Express)
```typescript
import { OpenAPIHono } from '@hono/zod-openapi';
import { createRoute, z } from '@hono/zod-openapi';

const app = new OpenAPIHono();

const createUserRoute = createRoute({
  method: 'post',
  path: '/users',
  request: {
    body: { content: { 'application/json': { schema: CreateUserSchema } } },
  },
  responses: {
    201: { content: { 'application/json': { schema: UserSchema } }, description: 'Created' },
  },
});

app.openapi(createUserRoute, async (c) => {
  const body = c.req.valid('json'); // fully typed, validated
  const user = await createUser(body);
  return c.json(user, 201);
});
```

## Step 4 — Keep Spec and Code in Sync
```bash
# In CI: validate spec is valid
npx @redocly/cli lint openapi.yaml

# Generate types and check for drift
npx openapi-typescript openapi.yaml -o src/types/api.d.ts
git diff --exit-code src/types/api.d.ts  # Fails CI if types drifted
```

## Verification Checklist
- [ ] All endpoints have `operationId`
- [ ] All error responses use `application/problem+json`
- [ ] TypeScript types auto-generated from spec (not hand-written)
- [ ] CI lints spec with `@redocly/cli`
- [ ] CI fails if generated types drift from spec
