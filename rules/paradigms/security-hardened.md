# Security-Hardened Development Rules

## 1. Input Validation
1. **Validate all external input**: Every value from users, APIs, files, or environment must be validated at the boundary.
2. **Allowlist over blocklist**: Validate what is allowed, not what is forbidden.
3. **Parameterized queries always**: Never construct SQL with string concatenation. Use prepared statements.

## 2. Authentication & Authorization
1. **AuthZ at data layer**: Authorization checks must be at the service/repository layer, not just the route handler.
2. **Short-lived tokens**: JWT access tokens must expire in ≤ 1 hour. Use refresh tokens for longer sessions.
3. **Secure cookie flags**: Session cookies must have `HttpOnly`, `Secure`, and `SameSite=Strict`.

## 3. Secrets Management
1. **No secrets in source code**: All secrets in environment variables or a secrets manager (IBM Secrets Manager, HashiCorp Vault).
2. **No secrets in logs**: Scrub sensitive fields before logging.
3. **Rotate on exposure**: Any secret committed to git must be rotated immediately, even if the commit was reverted.

## 4. Dependencies
1. **Regular audits**: Run `npm audit`, `pip-audit`, or `cargo audit` weekly in CI.
2. **Pin major versions**: Lock dependency major versions to prevent supply chain attacks.
