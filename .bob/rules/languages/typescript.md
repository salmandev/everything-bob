# TypeScript Rules

## 1. Type Safety
1. **No `any`**: Never use `any`. Use `unknown` for genuinely unknown types, then narrow with type guards.
2. **No `as` casts without evidence**: Only cast when you have verified the type is correct. Prefer type guards.
3. **Strict mode**: All TypeScript projects must have `"strict": true` in `tsconfig.json`.
4. **Explicit return types**: Public functions and exported functions must have explicit return type annotations.

## 2. Schemas & Validation
1. **Validate external data with Zod**: All data crossing system boundaries (API responses, form inputs, env vars) must be validated with Zod schemas.
2. **Infer types from schemas**: Use `z.infer<typeof MySchema>` instead of duplicating type definitions.

## 3. Imports & Modules
1. **ESM only**: Use `import`/`export` syntax. No `require()`.
2. **Explicit extensions in Node ESM**: When using Node.js with ESM, use `.js` extensions in imports (even for `.ts` files).
3. **No default exports for utilities**: Use named exports for utility modules.

## 4. Error Handling
1. **No swallowed errors**: Never `catch (e) {}` with an empty body. Log or rethrow.
2. **Result types for expected failures**: Use `Result<T, E>` patterns for operations that can fail expectedly.

## 5. Async/Await
1. **Always await**: Never fire-and-forget async functions without error handling.
2. **Parallel when independent**: Use `Promise.all()` for independent async operations instead of sequential `await`.
