# Zero Trust Security Rules

## 1. Verify Explicitly
1. **Authenticate every request**: No implicit trust based on network location. Every API call must present a verifiable identity.
2. **Short-lived credentials**: Access tokens expire in ≤ 1 hour. Machine-to-machine tokens expire in ≤ 24 hours.
3. **Multi-factor for admin**: All administrative actions require MFA, even for internal tools.

## 2. Least Privilege Access
1. **Minimal scopes**: Request only the permissions a service actually needs. Do not use wildcard permissions.
2. **Role separation**: Production credentials must be separate from development credentials.
3. **Audit all access**: Log every authorization decision (granted and denied) with the identity and resource.

## 3. Assume Breach
1. **Encrypt in transit and at rest**: TLS 1.3 minimum. Encrypt sensitive fields in the database.
2. **Network segmentation**: Services communicate only with the services they explicitly need to.
3. **Incident response**: Every team must have a documented runbook for credential rotation.
