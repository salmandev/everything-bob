---
name: security-audit
description: >-
  Use when the user wants to audit code for security vulnerabilities, scan for hardcoded secrets, check for OWASP Top 10 issues, review authentication or authorization logic, or run a dependency security check.
---

# Security Audit

Systematically audit code for security vulnerabilities. Never guess — inspect evidence.

## Step 1 — Scan for Hardcoded Secrets
1. Use `grep` with patterns: `(password|secret|api_key|token|private_key)\s*=\s*["'][^"']+["']`
2. Scan `.env` files, config files, and git history: `git log -p --all | grep -i "password\|secret\|api_key"`
3. Report each finding with file path and line number.

## Step 2 — OWASP Top 10 Review
Check each category against the codebase:
1. **Injection**: SQL, command, LDAP injection — look for string concatenation in queries
2. **Broken Authentication**: session fixation, weak passwords, missing MFA
3. **Sensitive Data Exposure**: unencrypted PII, weak ciphers, missing HTTPS enforcement
4. **Security Misconfiguration**: default credentials, verbose error messages, open CORS
5. **XSS**: unsanitized user input rendered to HTML
6. **Insecure Deserialization**: `eval()`, `pickle.loads()`, `JSON.parse()` on untrusted input
7. **Vulnerable Dependencies**: run `npm audit` / `pip-audit` / `cargo audit`

## Step 3 — Authentication & Authorization Review
1. Verify all protected routes check authentication before serving data.
2. Verify authorization checks exist at the data layer, not just the route layer.
3. Check for privilege escalation paths.

## Step 4 — Dependency Audit
```bash
# Node.js — flag moderate and above
npm audit --audit-level=moderate

# PHP / Composer ≥ 2.4
composer audit

# Python
pip-audit

# Java / Maven (CVSS ≥ 7 fails build)
mvn org.owasp:dependency-check-maven:check -DfailBuildOnCVSS=7

# Go
govulncheck ./...

# Rust
cargo audit

# Universal multi-ecosystem (images, filesystems, SBOMs)
grype dir:.
```

## Step 4b — Recent CVE Spot-Checks (last 90 days)

Cross-reference the stack against high-impact recent CVEs.
Activate the `cve-mitigator` skill for a full per-ecosystem triage walkthrough
with exact version pins, exploit descriptions, and Nginx hardening configs.

Quick single-command check:
```bash
# Node — check specific package versions
npm list path-to-regexp nanoid cross-spawn

# Java — look for Log4Shell / Text4Shell in tree
mvn dependency:tree | grep -E "log4j|commons-text|spring"

# PHP — confirm PHP version is patched
php -v   # should be ≥ 8.1.31 / 8.2.26 / 8.3.14

# Nginx — confirm version
nginx -v 2>&1
```

## Step 5 — Report Findings
For each finding:
- **Severity**: Critical / High / Medium / Low
- **Location**: File path + line number
- **Description**: What the vulnerability is
- **Remediation**: Concrete fix

## Verification Checklist
- [ ] No hardcoded secrets found (or all documented and remediation planned)
- [ ] OWASP Top 10 reviewed
- [ ] Dependency audit run with no critical/high vulnerabilities
- [ ] Auth/authz logic verified
