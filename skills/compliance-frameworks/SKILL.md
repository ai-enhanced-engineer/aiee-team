---
name: compliance-frameworks
description: Security and privacy compliance patterns for B2B SaaS (SOC 2, GDPR). Use for audit preparation, control design, compliance gap analysis, or building compliance into features.
---

# Compliance Frameworks Skill

Security and privacy compliance patterns for B2B SaaS products.

## When to Use

- Preparing for SOC 2 Type II audit
- Implementing GDPR data handling requirements
- Conducting compliance gap analysis
- Designing controls for audit evidence
- Building compliance into new features

## Quick Reference

### SOC 2 Trust Principles

| Principle | Key Controls | Priority |
|-----------|--------------|----------|
| **Security** | Access control, encryption, monitoring | Required |
| **Availability** | Uptime SLAs, redundancy, backups | Required |
| **Processing Integrity** | Input validation, error handling | Conditional |
| **Confidentiality** | Data classification, encryption | Common |
| **Privacy** | Consent, access requests, retention | If PII handled |

### GDPR Rights (Data Subject)

| Right | Implementation | Response Time |
|-------|----------------|---------------|
| Access | Data export endpoint | 30 days |
| Erasure | Deletion workflow | 30 days |
| Rectification | Edit profile | Reasonable |
| Portability | Machine-readable export | 30 days |
| Objection | Opt-out mechanisms | Immediate |

### Common Control Categories

| Category | Examples |
|----------|----------|
| **Preventive** | Access controls, input validation, encryption |
| **Detective** | Audit logging, anomaly detection, SIEM |
| **Corrective** | Incident response, patching, rollback |

## Key Patterns

### Control Design

```
Risk Identification → Control Selection → Implementation → Evidence Collection → Audit
```

### Evidence Types

| Type | Examples |
|------|----------|
| **Documentation** | Policies, procedures, diagrams |
| **Configuration** | Terraform, IAM policies, firewall rules |
| **Logs** | Audit trails, access logs, change records |
| **Screenshots** | Dashboard configs, settings, approvals |

## Integration with Development

### PR Checklist (Security-Sensitive Changes)

- [ ] No hardcoded secrets
- [ ] Access controls implemented
- [ ] Audit logging added
- [ ] Input validation present
- [ ] Error messages sanitized

### Compliance by Design

Build compliance into features from the start:

1. **Data Classification** - What data is being handled?
2. **Access Control** - Who can access it?
3. **Audit Trail** - What operations are logged?
4. **Retention** - How long is data kept?
5. **Deletion** - How is data removed?

## Files

- `reference.md` - Detailed checklists, control mappings
- `examples.md` - Implementation patterns, evidence templates
