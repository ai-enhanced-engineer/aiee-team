---
name: infra-terraform
description: Modern Terraform patterns for module design, state management, and CI/CD integration. Use for structuring Terraform projects, managing remote state, implementing environment separation, or enforcing code quality.
---

# Terraform Patterns

Modern Infrastructure as Code patterns for Terraform, emphasizing modularity, safety, and team collaboration.

## Core Principles

| Principle | Implementation |
|-----------|---------------|
| **Treat as code** | Version control, code review, CI/CD |
| **Don't Repeat Yourself** | Modules for reusable patterns |
| **Explicit > Implicit** | tfvars over workspaces, directories over conditionals |
| **Plan before apply** | Always review terraform plan |
| **Remote state** | Never local state in production |

**Note:** HashiCorp changed Terraform license (BSL). OpenTofu is the community MPL-2.0 fork.

## Standard Module Structure

```
modules/
└── cloud-sql/
    ├── main.tf          # Resources
    ├── variables.tf     # Inputs with validation
    ├── outputs.tf       # Outputs for other modules
    ├── versions.tf      # Provider constraints
    ├── README.md        # Documentation
    └── examples/
        └── basic/
            └── main.tf  # Usage example
```

### Design Guidelines

1. **Single responsibility** - One logical component per module
2. **Sensible defaults** - Work out-of-the-box
3. **Validate inputs** - Catch errors early
4. **Explicit outputs** - Clear contract
5. **Semantic versioning** - Tag releases

## Environment Separation

### Recommended: Directory per Environment

```
environments/
├── staging/
│   ├── main.tf
│   ├── terraform.tfvars
│   └── backend.tf
└── production/
    ├── main.tf
    ├── terraform.tfvars
    └── backend.tf
```

**Why:** Complete isolation, separate state, clear boundaries

### Alternative: tfvars Files

```
terraform/
├── main.tf
├── variables.tf
└── environments/
    ├── staging.tfvars
    └── production.tfvars

# Usage
terraform plan -var-file=environments/staging.tfvars
```

**Why:** Less duplication when environments are similar

### Avoid: Workspaces for Environments

Workspaces share code, making it easy to apply wrong config.

## State Management

### Remote Backend (Required)

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state"
    prefix = "terraform/state"
  }
}
```

### State Safety

- **Enable versioning** - Recover from corruption
- **Enable locking** - Prevent concurrent modifications
- **Encrypt at rest** - State contains secrets
- **Restrict access** - IAM for state bucket
- **Never edit manually** - Use `terraform state` commands

### Handling State Issues

| Issue | Solution |
|-------|----------|
| Lock stuck | `terraform force-unlock <ID>` |
| Drift detected | Plan shows unexpected changes |
| Import needed | `terraform import <resource> <id>` |
| State corruption | Restore from versioned backup |

## CI/CD Integration

### Pipeline Stages

```yaml
stages:
  - validate    # fmt, validate
  - plan        # terraform plan
  - approve     # manual gate (production)
  - apply       # terraform apply
```

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      - id: terraform_docs
```

## Critical Rules

1. **Never store secrets in tfvars** - Use Secret Manager, reference dynamically
2. **Lock provider versions** - Commit `.terraform.lock.hcl`
3. **Review every plan** - Especially destroys
4. **Tag module versions** - `?ref=v1.2.3`
5. **Plan in CI** - Detect drift early

See `reference.md` for detailed patterns and `examples.md` for CI/CD templates.
