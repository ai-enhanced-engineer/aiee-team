# Terraform Patterns Reference

## Module Design

### Variable Best Practices

```hcl
# variables.tf

# Required variable with validation
variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be 'staging' or 'production'."
  }
}

# Optional with sensible default
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

# Complex type with defaults
variable "network_config" {
  description = "Network configuration"
  type = object({
    vpc_id     = string
    subnet_ids = list(string)
    private    = optional(bool, true)
  })
}

# Sensitive variable
variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
```

### Output Patterns

```hcl
# outputs.tf

# Simple output
output "instance_id" {
  description = "The ID of the created instance"
  value       = google_compute_instance.main.id
}

# Conditional output
output "public_ip" {
  description = "Public IP if assigned"
  value       = var.assign_public_ip ? google_compute_instance.main.network_interface[0].access_config[0].nat_ip : null
}

# Sensitive output
output "connection_string" {
  description = "Database connection string"
  value       = "postgresql://${var.username}:${var.password}@${google_sql_database_instance.main.private_ip_address}/${var.database_name}"
  sensitive   = true
}

# Structured output
output "instance_details" {
  description = "Full instance details"
  value = {
    id         = google_compute_instance.main.id
    name       = google_compute_instance.main.name
    private_ip = google_compute_instance.main.network_interface[0].network_ip
    zone       = google_compute_instance.main.zone
  }
}
```

## Provider Configuration

### Version Constraints

```hcl
# versions.tf

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"  # Allow 5.x updates
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}
```

## State Management

### Backend Configuration

```hcl
# backend.tf

terraform {
  backend "gcs" {
    bucket = "company-terraform-state"
    prefix = "projects/my-project/staging"
  }
}
```

### State Commands

```bash
# List all resources in state
terraform state list

# Show specific resource
terraform state show google_sql_database_instance.main

# Import existing resource
terraform import google_sql_database_instance.main projects/my-project/instances/my-db

# Force unlock stuck state
terraform force-unlock LOCK_ID
```

## Lifecycle Rules

```hcl
resource "google_compute_instance" "main" {
  name         = var.name
  machine_type = var.machine_type

  lifecycle {
    # Prevent accidental destruction
    prevent_destroy = true

    # Ignore changes to specific attributes
    ignore_changes = [
      metadata["ssh-keys"],
      labels["updated_by"],
    ]

    # Replace before destroy (for zero-downtime)
    create_before_destroy = true

    # Custom replacement trigger
    replace_triggered_by = [
      google_secret_manager_secret_version.config
    ]
  }
}
```

## Count vs For_Each

```hcl
# Count: for identical resources
resource "google_compute_instance" "workers" {
  count = var.worker_count
  name  = "worker-${count.index}"
}

# For_each with set: for unique resources
resource "google_compute_instance" "named" {
  for_each = toset(["web", "api", "worker"])
  name     = "server-${each.key}"
}

# For_each with map: for resources with different configs
resource "google_compute_instance" "configured" {
  for_each = {
    web    = { machine_type = "e2-medium", disk_size = 50 }
    api    = { machine_type = "e2-standard-2", disk_size = 100 }
    worker = { machine_type = "e2-standard-4", disk_size = 200 }
  }

  name         = "server-${each.key}"
  machine_type = each.value.machine_type

  boot_disk {
    initialize_params {
      size = each.value.disk_size
    }
  }
}
```
