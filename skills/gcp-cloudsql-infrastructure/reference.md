# Cloud SQL Infrastructure Reference

Detailed configuration patterns for Cloud SQL PostgreSQL provisioning.

## Sizing Calculations

### Memory Requirements

PostgreSQL memory usage:
```
shared_buffers = 25% of RAM (managed by Cloud SQL)
work_mem = 4MB per connection (default)
maintenance_work_mem = 64MB (for vacuums, indexes)

Effective RAM = Total RAM - shared_buffers - OS overhead
```

### Connection Count Formula

```
Max connections = (RAM in MB / 10) - 50

db-f1-micro (614MB): ~11 connections (too low for production)
db-g1-small (1.7GB): ~120 connections
db-standard-1 (3.75GB): ~325 connections
db-standard-2 (7.5GB): ~700 connections
```

### Storage Sizing

```
Initial storage = Current data + 3x growth buffer

Minimum recommendations:
- Dev: 10GB (minimum allowed)
- Staging: 20-50GB
- Production: 50-100GB starting, autogrow enabled
```

---

## VPC Networking

### Private IP Configuration

Cloud SQL with private IP requires:
1. **Private Service Access** configured in VPC
2. **VPC Peering** between your VPC and Google's service VPC
3. **No public IP** on the instance (security best practice)

### Connection Methods

| From | Method | Latency | Use Case |
|------|--------|---------|----------|
| Cloud Run | VPC Connector | <1ms | Production |
| Cloud Run | Direct VPC Egress | <1ms | Cost optimization |
| Local dev | Cloud SQL Proxy | Variable | Development |
| Cloud Build | Cloud SQL Proxy | Variable | Migrations |

---

## Performance Tuning

### Key PostgreSQL Parameters

Cloud SQL manages most parameters, but you can tune:

| Parameter | Default | Recommendation |
|-----------|---------|----------------|
| `max_connections` | Auto | Usually sufficient |
| `statement_timeout` | 0 (none) | Set to 30s for safety |
| `log_min_duration_statement` | -1 (off) | 1000ms for slow query logging |

---

## Backup and Recovery

### Backup Types

| Type | Frequency | Retention | Recovery Time |
|------|-----------|-----------|---------------|
| Automated | Daily | 3-30 days | 10-30 minutes |
| On-demand | Manual | Until deleted | 10-30 minutes |
| PITR | Continuous | 7 days | Minutes |

---

## Cost Optimization

### Cost Reduction Strategies

| Strategy | Savings | Trade-off |
|----------|---------|-----------|
| db-g1-small -> db-f1-micro | 40% | CPU throttling, limited connections |
| SSD -> HDD | 47% | Higher latency (10-20ms vs 1-5ms) |
| REGIONAL -> ZONAL | 26% | No automatic failover |
| Reduce backup retention | Minor | Less recovery options |

---

## Troubleshooting

### Common Issues

| Error | Cause | Fix |
|-------|-------|-----|
| "Connection refused" | Private IP not configured | Enable VPC peering |
| "Too many connections" | Pool exhaustion | Increase tier or optimize pooling |
| "Disk full" | Autogrow disabled or limit reached | Enable autogrow, increase limit |
| "Instance in maintenance" | Maintenance window active | Wait or reschedule |
