# Infrastructure as Code Rules

## 1. Terraform Standards
1. **State in remote backend**: Never use local state. Use S3+DynamoDB, Terraform Cloud, or equivalent.
2. **Workspaces for environments**: Use separate workspaces or state files for dev/staging/prod.
3. **`terraform plan` before apply**: Always review the plan. Never run `apply` without reviewing the diff.
4. **No hardcoded values**: All environment-specific values in `variables.tf`. No hardcoded ARNs, IPs, or region strings in resources.

## 2. Idempotency
1. **Resources are declarative**: Every resource must be safe to `apply` multiple times without side effects.
2. **Data sources for existing resources**: Use `data` blocks for resources you did not create with Terraform.

## 3. Security
1. **No secrets in tfvars**: Use environment variables (`TF_VAR_`) or a secrets manager reference.
2. **Restrict provider permissions**: The Terraform IAM role must have only the permissions required for the managed resources.
