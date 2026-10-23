---
name: oauth2-oidc-flows
description: >-
  Use when the user wants to implement OAuth 2.0 or OpenID Connect, add social login (Google, GitHub), implement PKCE flow, build a protected API with JWT bearer tokens, set up Auth0 or Keycloak, or debug OAuth redirect issues.
---

# OAuth 2.0 & OIDC Flows

Implement secure OAuth 2.0 and OpenID Connect authentication correctly.

## Step 1 — Choose the Right Flow
| Flow | Use When |
| --- | --- |
| **Authorization Code + PKCE** | SPAs, mobile apps — always use PKCE |
| **Authorization Code** | Server-side web apps with client secret |
| **Client Credentials** | Machine-to-machine (no user involved) |
| **Device Code** | CLI tools, TV apps |
| **Implicit** | ⚠️ Deprecated — never use |

## Step 2 — Authorization Code Flow with PKCE (SPA/Mobile)
```typescript
// 1. Generate PKCE challenge
const generatePKCE = async () => {
  const verifier = crypto.getRandomValues(new Uint8Array(32));
  const verifierB64 = btoa(String.fromCharCode(...verifier))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');

  const hash = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(verifierB64));
  const challengeB64 = btoa(String.fromCharCode(...new Uint8Array(hash)))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');

  return { verifier: verifierB64, challenge: challengeB64 };
};

// 2. Redirect to authorization endpoint
const { verifier, challenge } = await generatePKCE();
sessionStorage.setItem('pkce_verifier', verifier);

const params = new URLSearchParams({
  response_type: 'code',
  client_id: CLIENT_ID,
  redirect_uri: REDIRECT_URI,
  scope: 'openid profile email',
  state: crypto.randomUUID(), // CSRF protection
  code_challenge: challenge,
  code_challenge_method: 'S256',
});
window.location.href = `${AUTH_SERVER}/authorize?${params}`;

// 3. Exchange code for tokens (callback page)
const code = new URLSearchParams(window.location.search).get('code');
const res = await fetch(`${AUTH_SERVER}/oauth/token`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  body: new URLSearchParams({
    grant_type: 'authorization_code',
    code: code!,
    redirect_uri: REDIRECT_URI,
    client_id: CLIENT_ID,
    code_verifier: sessionStorage.getItem('pkce_verifier')!,
  }),
});
const { access_token, id_token, refresh_token } = await res.json();
```

## Step 3 — Validate JWT Access Tokens (API Server)
```typescript
import jwt from 'jsonwebtoken';
import jwksClient from 'jwks-rsa';

const client = jwksClient({ jwksUri: `${AUTH_SERVER}/.well-known/jwks.json` });

const verifyToken = async (token: string) => {
  const decoded = jwt.decode(token, { complete: true });
  const key = await client.getSigningKey(decoded?.header.kid);
  return jwt.verify(token, key.getPublicKey(), {
    audience: API_AUDIENCE,
    issuer: AUTH_SERVER,
    algorithms: ['RS256'],
  });
};

// Express middleware
export const requireAuth = async (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'No token' });
  try {
    req.user = await verifyToken(token);
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
};
```

## Step 4 — Client Credentials (M2M)
```typescript
// Service-to-service authentication
const getServiceToken = async () => {
  const res = await fetch(`${AUTH_SERVER}/oauth/token`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      grant_type: 'client_credentials',
      client_id: process.env.SERVICE_CLIENT_ID,
      client_secret: process.env.SERVICE_CLIENT_SECRET,
      audience: TARGET_API_AUDIENCE,
    }),
  });
  const { access_token, expires_in } = await res.json();
  // Cache the token until expires_in - 60 seconds
  return access_token;
};
```

## Step 5 — Token Storage Security
| Location | XSS risk | CSRF risk | Recommendation |
| --- | --- | --- | --- |
| `localStorage` | High | Low | ❌ Never for access tokens |
| `sessionStorage` | High | Low | ⚠️ Only for PKCE verifier |
| `HttpOnly` cookie | None | Medium | ✅ Best for session tokens |
| Memory (JS variable) | Low | Low | ✅ Best for access tokens |

## Verification Checklist
- [ ] PKCE used for all browser/mobile flows (never Implicit)
- [ ] `state` parameter validated on callback to prevent CSRF
- [ ] Access tokens stored in memory, not localStorage
- [ ] Token signature verified against JWKS on every API request
- [ ] Tokens refreshed before expiry, not after 401
