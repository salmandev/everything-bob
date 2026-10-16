---
name: terraform-architect
description: >-
  Use when the user wants to write Terraform infrastructure code, plan a Terraform architecture, manage remote state, refactor Terraform modules, or debug a Terraform apply failure.
---

# Terraform Architect

Design and implement Terraform infrastructure with remote state, modular organization, and security best practices.

## Step 1 — Initialize with Remote State
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

## Step 2 — Organize into Modules
```
infrastructure/
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    ecs-service/
      main.tf
      variables.tf
      outputs.tf
  environments/
    prod/
      main.tf       # calls modules
      variables.tf
    staging/
      main.tf
```

## Step 3 — Always Plan Before Apply
```bash
terraform init
terraform plan -out=tfplan
# Review the plan carefully
terraform apply tfplan
```

## Step 4 — Use Variables for All Environment Differences
```hcl
variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_count" {
  type    = number
  default = 1
}
```

## Verification Checklist
- [ ] Remote state configured
- [ ] `terraform plan` reviewed before apply
- [ ] No hardcoded secrets
- [ ] All resources tagged with environment and team
- [ ] `terraform validate` passes
