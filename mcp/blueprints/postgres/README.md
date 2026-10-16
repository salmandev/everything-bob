# PostgreSQL MCP Server

Gives Bob direct read/write SQL access to a PostgreSQL database.

## Installation
```json
"postgres": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres", "${DATABASE_URL}"]
}
```

## Security Notes
- Use a **read-only** database user for Bob in production
- Only give write access in development environments
- Never use the superuser or `postgres` account
- Consider row-level security (RLS) to limit Bob's data access

## Recommended Setup
```sql
-- Create a read-only role for Bob
CREATE ROLE bob_readonly;
GRANT CONNECT ON DATABASE mydb TO bob_readonly;
GRANT USAGE ON SCHEMA public TO bob_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO bob_readonly;
CREATE USER bob_user WITH PASSWORD 'strong-password';
GRANT bob_readonly TO bob_user;
```
