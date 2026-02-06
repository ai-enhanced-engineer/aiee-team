# Compliance Frameworks - Reference

Detailed checklists and control mappings for SOC 2 and GDPR.

## SOC 2 Type II

### Trust Services Criteria (TSC)

#### Security (CC - Common Criteria)

| Control ID | Requirement | Implementation |
|------------|-------------|----------------|
| **CC1.1** | COSO environment | Documented security policy |
| **CC2.1** | Communication | Security training, onboarding |
| **CC3.1** | Risk assessment | Annual security review |
| **CC4.1** | Monitoring | Continuous logging, alerting |
| **CC5.1** | Control activities | Access reviews, change management |
| **CC6.1** | Logical access | SSO, MFA, RBAC |
| **CC6.6** | Encryption | TLS 1.3, encryption at rest |
| **CC7.1** | System monitoring | Intrusion detection, SIEM |
| **CC7.3** | Security incidents | Incident response procedure |
| **CC8.1** | Change management | PR reviews, staging environment |
| **CC9.2** | Vendor management | Third-party risk assessment |

#### Availability (A)

| Control ID | Requirement | Implementation |
|------------|-------------|----------------|
| **A1.1** | Capacity planning | Auto-scaling, resource monitoring |
| **A1.2** | Recovery | Backup and restore procedures |
| **A1.3** | Disaster recovery | Multi-region failover |

#### Privacy (P)

| Control ID | Requirement | Implementation |
|------------|-------------|----------------|
| **P1.1** | Notice | Privacy policy |
| **P2.1** | Choice/Consent | Opt-in mechanisms |
| **P3.1** | Collection limitation | Data minimization |
| **P4.1** | Use/Retention | Retention policy |
| **P5.1** | Access | Data export endpoint |

### Audit Preparation Checklist

```markdown
## 3 Months Before Audit

- [ ] Engage SOC 2 auditor
- [ ] Define audit scope (which trust principles)
- [ ] Conduct gap assessment
- [ ] Remediate critical findings
- [ ] Begin evidence collection

## 1 Month Before Audit

- [ ] Complete all control implementations
- [ ] Organize evidence repository
- [ ] Conduct internal audit walkthrough
- [ ] Train team on auditor interactions
- [ ] Prepare system descriptions

## During Audit (Type II - 3-12 month period)

- [ ] Provide evidence upon request
- [ ] Facilitate auditor interviews
- [ ] Address any findings promptly
- [ ] Maintain normal operations (evidence of controls working)
```

---

## GDPR Compliance

### Lawful Basis for Processing

| Basis | When Applicable | Evidence Required |
|-------|-----------------|-------------------|
| **Consent** | Marketing, optional features | Opt-in records, consent language |
| **Contract** | Core service delivery | Service agreement, terms |
| **Legitimate Interest** | Analytics, security | LIA documentation |
| **Legal Obligation** | Tax records, subpoenas | Legal requirements |

### Data Subject Rights Implementation

#### Right to Access (Article 15)

```python
class DataExportService:
    async def export_customer_data(self, customer_id: str) -> DataExport:
        """Export all customer data in machine-readable format."""
        return DataExport(
            customer_profile=await self.get_profile(customer_id),
            conversations=await self.get_all_conversations(customer_id),
            export_date=datetime.utcnow(),
            format="json"
        )
```

#### Right to Erasure (Article 17)

```python
class DataDeletionService:
    async def delete_customer_data(self, customer_id: str) -> DeletionConfirmation:
        """Delete all customer data (right to be forgotten)."""
        # 1. Identify all data locations
        locations = await self.scan_data_locations(customer_id)

        # 2. Delete from each location
        for location in locations:
            await self.delete_from_location(location, customer_id)

        # 3. Log deletion (without PII)
        await self.log_deletion_event(customer_id_hash=hash(customer_id))

        return DeletionConfirmation(completed_at=datetime.utcnow())
```

### Privacy by Design Checklist

```markdown
## New Feature Privacy Review

- [ ] What personal data is collected?
- [ ] Is collection necessary (data minimization)?
- [ ] What is the lawful basis?
- [ ] Where is data stored?
- [ ] Who has access?
- [ ] How long is it retained?
- [ ] How can it be deleted?
- [ ] Is it transferred outside EU?
```

---

## Common Control Mappings

### Access Control Implementation

| Layer | Control | Tool |
|-------|---------|------|
| **Identity** | SSO, MFA | Google Workspace, Okta |
| **Authorization** | RBAC | Custom roles, IAM policies |
| **Database** | RLS | PostgreSQL policies |
| **API** | JWT validation | FastAPI middleware |
| **Secrets** | Rotation | GCP Secret Manager |

### Audit Logging Requirements

| Event | Details to Log | Retention |
|-------|----------------|-----------|
| **Authentication** | User, timestamp, success/fail, IP | 1 year |
| **Authorization** | Resource, action, decision | 1 year |
| **Data Access** | User, resource, query | 90 days |
| **Data Modification** | User, old/new values (hashed) | 1 year |
| **Admin Actions** | User, action, target | 2 years |

### Encryption Standards

| Context | Minimum Standard | Recommended |
|---------|------------------|-------------|
| **In Transit** | TLS 1.2 | TLS 1.3 |
| **At Rest (DB)** | AES-256 | AES-256-GCM |
| **Passwords** | bcrypt (cost 10) | bcrypt (cost 12+) |
| **API Keys** | SHA-256 hash | Argon2id |

---

## Incident Response

### Security Incident Classification

| Severity | Criteria | Response Time | Notification |
|----------|----------|---------------|--------------|
| **Critical** | Data breach confirmed | Immediate | CEO, Legal, Affected customers |
| **High** | Potential breach | 4 hours | Security team, Engineering lead |
| **Medium** | Vulnerability exploited | 24 hours | Security team |
| **Low** | Security improvement | Sprint | Backlog |

### Breach Notification Requirements

| Regulation | Timeline | Recipient | Threshold |
|------------|----------|-----------|-----------|
| **GDPR** | 72 hours | Supervisory authority | Risk to rights |
| **GDPR** | Without delay | Data subjects | High risk |
| **SOC 2** | Per contract | Customers | Material incidents |
