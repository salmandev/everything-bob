---
name: api-craftsman
description: >-
  Use when the user wants to design a REST API, write an OpenAPI spec, design gRPC protos, define API error formats, create API versioning strategy, or review an existing API design.
---

# API Craftsman

Design APIs contract-first. The spec drives the implementation, not the other way.

## Step 1 — Define the Resource Model
1. Identify all resources (nouns) and their relationships.
2. Map CRUD operations to HTTP methods: GET/POST/PUT/PATCH/DELETE.
3. Define resource URLs: `/{resource}/{id}`, `/{resource}/{id}/{sub-resource}`.

## Step 2 — Write OpenAPI 3.1 Specification
```yaml
openapi: "3.1.0"
info:
  title: My API
  version: "1.0.0"
paths:
  /users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        "200":
          description: User found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "404":
          $ref: "#/components/responses/NotFound"
components:
  schemas:
    User:
      type: object
      required: [id, email]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
  responses:
    NotFound:
      description: Resource not found
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
```

## Step 3 — Apply RFC 7807 Problem Details for Errors
All error responses use `Content-Type: application/problem+json`.

## Step 4 — Define Versioning Strategy
- URL versioning: `/v1/users` (simple, cache-friendly)
- Header versioning: `Accept: application/vnd.myapi.v1+json` (clean URLs)

## Verification Checklist
- [ ] All endpoints documented in OpenAPI spec
- [ ] All error responses follow RFC 7807
- [ ] Authentication scheme documented
- [ ] Breaking changes identified and versioning strategy defined
