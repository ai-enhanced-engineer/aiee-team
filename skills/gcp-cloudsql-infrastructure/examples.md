# Cloud SQL Infrastructure Examples

Complete Terraform configurations for Cloud SQL PostgreSQL deployments.

## Staging Environment Configuration

Cost-optimized configuration for staging/development.

```hcl
# staging.tfvars

# Cloud SQL Configuration
db_tier           = "db-g1-small"
db_disk_size      = 20
db_disk_type      = "PD_HDD"
db_availability   = "ZONAL"
db_backup_enabled = true
db_backup_count   = 3
db_pitr_enabled   = false

# Estimated cost: ~$30/month
```

### Core Terraform Module

```hcl
# modules/cloudsql/main.tf

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "network_id" {
  description = "VPC network ID for private IP"
  type        = string
}

variable "db_tier" {
  description = "Cloud SQL machine tier"
  type        = string
  default     = "db-g1-small"
}

variable "db_disk_size" {
  description = "Initial disk size in GB"
  type        = number
  default     = 20
}

variable "db_disk_type" {
  description = "Disk type: PD_SSD or PD_HDD"
  type        = string
  default     = "PD_HDD"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "appdb"
}

# Random suffix for instance name (required for recreation)
resource "random_id" "db_suffix" {
  byte_length = 4
}

# Cloud SQL Instance
resource "google_sql_database_instance" "main" {
  name             = "${var.project_id}-${var.environment}-db-${random_id.db_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = var.db_tier
    availability_type = var.environment == "production" ? "REGIONAL" : "ZONAL"
    disk_type         = var.db_disk_type
    disk_size         = var.db_disk_size
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = var.environment == "production"
      start_time                     = "03:00"

      backup_retention_settings {
        retained_backups = var.environment == "production" ? 30 : 3
      }
    }

    maintenance_window {
      day          = 7  # Sunday
      hour         = 4  # 4 AM UTC
      update_track = "stable"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "1000"
    }
  }

  deletion_protection = var.environment == "production"

  lifecycle {
    prevent_destroy = false
  }
}

# Database
resource "google_sql_database" "main" {
  name     = var.database_name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

# Application User
resource "random_password" "app_password" {
  length  = 32
  special = false
}

resource "google_sql_user" "app" {
  name     = "app_user"
  instance = google_sql_database_instance.main.name
  password = random_password.app_password.result
  project  = var.project_id
}

# Outputs
output "instance_name" {
  value       = google_sql_database_instance.main.name
  description = "Cloud SQL instance name"
}

output "private_ip" {
  value       = google_sql_database_instance.main.private_ip_address
  description = "Private IP address for database connections"
}

output "connection_name" {
  value       = google_sql_database_instance.main.connection_name
  description = "Connection name for Cloud SQL Proxy"
}

output "app_user_password" {
  value       = random_password.app_password.result
  sensitive   = true
  description = "Application user password (store in Secret Manager)"
}
```

---

## Tier Upgrade Example

Changing from staging to production-like configuration.

```hcl
# Before: staging configuration
db_tier           = "db-g1-small"   # $28/mo
db_disk_type      = "PD_HDD"        # $0.09/GB
availability_type = "ZONAL"         # Base cost

# After: production-like configuration
db_tier           = "db-standard-1" # $68/mo (+$40)
db_disk_type      = "PD_SSD"        # $0.17/GB (+$1.60 for 20GB)
availability_type = "REGIONAL"      # +35% (~$24)

# Monthly cost increase: ~$66 (from $30 to $96)
```

### Terraform Plan Output

When upgrading, expect:

```
# google_sql_database_instance.main will be updated in-place
~ resource "google_sql_database_instance" "main" {
    ~ settings {
        ~ tier              = "db-g1-small" -> "db-standard-1"
        ~ availability_type = "ZONAL" -> "REGIONAL"
        ~ disk_type         = "PD_HDD" -> "PD_SSD"
      }
  }
```

**Downtime expectations:**
- Tier change: ~30-60 seconds
- HA enable: 5-10 minutes
- Disk type change: May require instance restart
