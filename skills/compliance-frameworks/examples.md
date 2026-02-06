# Compliance Frameworks - Examples

Practical implementation patterns and templates for compliance controls.

## SOC 2 Evidence Examples

### Quarterly Access Review

```markdown
## Access Review - Q1 2025

**Reviewer:** Security Engineer
**Date:** 2025-01-15
**Scope:** Production infrastructure access

### Users Reviewed

| User | Role | Access Level | Decision | Justification |
|------|------|--------------|----------|---------------|
| alice@company.ai | Engineer | production-deployer | Retain | Active deployment duties |
| bob@company.ai | Former | admin | Revoke | Terminated 2024-12-01 |
| carol@company.ai | Support | read-only | Retain | Customer support role |

### Actions Taken

- [x] Removed bob@company.ai from all groups
- [x] Revoked bob@company.ai API keys
- [x] Audit of bob's recent access (no anomalies)

### Certification

I certify this access review was conducted in accordance with policy.

**Signature:** [Digital signature]
**Date:** 2025-01-15
```

### Pull Request Template

```markdown
## Change Description

[Brief description of the change]

## Security Checklist

- [ ] No secrets in code
- [ ] Input validation added
- [ ] Access controls verified
- [ ] Audit logging included
- [ ] Error messages sanitized

## Testing Evidence

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Security scan clean
- [ ] Staging deployment verified

## Rollback Plan

[How to rollback if issues occur]

## Approvals Required

- [ ] Code reviewer
- [ ] Security review (if security-sensitive)
- [ ] Product owner (if user-facing)
```

### Incident Ticket Template

```markdown
## Incident: [INCIDENT-2025-001]

### Summary
[One-line description]

### Timeline (UTC)

| Time | Event |
|------|-------|
| 2025-01-15 14:30 | Alert triggered |
| 2025-01-15 14:35 | Incident declared |
| 2025-01-15 14:45 | Root cause identified |
| 2025-01-15 15:00 | Mitigation applied |
| 2025-01-15 15:30 | Incident resolved |

### Impact

- **Duration:** 1 hour
- **Users Affected:** ~500
- **Data Exposure:** None

### Root Cause

[Detailed description of what caused the incident]

### Resolution

[What was done to resolve the incident]

### Follow-up Actions

- [ ] Post-incident review scheduled
- [ ] Prevention measures identified
- [ ] Documentation updated
```

---

## GDPR Implementation Examples

### Data Export API

```python
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()

class DataExport(BaseModel):
    customer_id: str
    export_date: datetime
    profile: dict
    widgets: list[dict]
    conversations: list[dict]
    format: str = "json"

@router.get("/api/v1/dashboard/data-export")
async def export_my_data(
    current_user: Customer = Depends(get_current_customer)
) -> DataExport:
    """
    GDPR Article 15 & 20: Right to Access & Portability

    Exports all personal data in machine-readable format.
    Response time: Within 30 days (usually instant).
    """
    return DataExport(
        customer_id=str(current_user.id),
        export_date=datetime.utcnow(),
        profile={
            "company_name": current_user.company_name,
            "contact_email": current_user.contact_email,
            "created_at": current_user.created_at.isoformat(),
        },
        widgets=await get_customer_widgets(current_user.id),
        conversations=await get_customer_conversations(current_user.id),
    )
```

---

## Audit Logging Examples

### Structured Audit Log

```python
import structlog
from datetime import datetime
from enum import Enum

class AuditAction(Enum):
    LOGIN = "login"
    LOGOUT = "logout"
    CREATE = "create"
    READ = "read"
    UPDATE = "update"
    DELETE = "delete"
    EXPORT = "export"

def audit_log(
    action: AuditAction,
    resource_type: str,
    resource_id: str,
    actor_id: str,
    actor_type: str = "customer",
    details: dict | None = None,
    outcome: str = "success"
):
    """
    Create structured audit log entry.

    SOC 2 CC4.1, CC7.2: Monitoring activities
    """
    logger = structlog.get_logger("audit")
    logger.info(
        "audit_event",
        timestamp=datetime.utcnow().isoformat(),
        action=action.value,
        resource_type=resource_type,
        resource_id=resource_id,
        actor_id=actor_id,
        actor_type=actor_type,
        outcome=outcome,
        details=details or {},
    )

# Usage examples
audit_log(
    action=AuditAction.LOGIN,
    resource_type="session",
    resource_id="sess_abc123",
    actor_id="cust_xyz789",
    details={"ip": "192.168.1.1", "mfa_used": True}
)

audit_log(
    action=AuditAction.DELETE,
    resource_type="widget",
    resource_id="widget_abc",
    actor_id="cust_xyz789",
    details={"widget_name": "Support Chat"}
)
```

### Log Query for Audit

```sql
-- Find all access to customer data in last 30 days
SELECT
    timestamp,
    json_extract(payload, '$.action') as action,
    json_extract(payload, '$.resource_type') as resource_type,
    json_extract(payload, '$.actor_id') as actor_id,
    json_extract(payload, '$.outcome') as outcome
FROM audit_logs
WHERE
    timestamp >= CURRENT_DATE - INTERVAL '30 days'
    AND json_extract(payload, '$.resource_type') IN ('customer', 'conversation', 'message')
ORDER BY timestamp DESC;
```
