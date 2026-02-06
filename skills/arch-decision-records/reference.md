# Architecture Decision Records Reference

Detailed guidance on creating and maintaining ADRs.

## History and Origin

Architecture Decision Records were popularized by Michael Nygard in his 2011 blog post "Documenting Architecture Decisions." The format has become a standard practice in software architecture.

**Key insight**: Traditional architecture documents become stale. ADRs capture decisions at the moment they're made, preserving context that's otherwise lost.

## ADR Lifecycle Management

### Status Transitions

```
┌──────────┐     ┌──────────┐
│ Proposed │ ──► │ Accepted │
└──────────┘     └────┬─────┘
                      │
         ┌────────────┼────────────┐
         ▼            ▼            ▼
   ┌──────────┐ ┌──────────┐ ┌───────────────┐
   │Deprecated│ │ Rejected │ │Superseded by X│
   └──────────┘ └──────────┘ └───────────────┘
```

### Status Definitions

| Status | Meaning | When to Use |
|--------|---------|-------------|
| **Proposed** | Under discussion | Decision not yet made |
| **Accepted** | Decision made | Ready for implementation |
| **Rejected** | Considered but not chosen | Document why (valuable context) |
| **Deprecated** | No longer applies | Context changed, decision irrelevant |
| **Superseded** | Replaced by newer decision | Link to new ADR |

### Changing Status

**Never change the content of an accepted ADR.** Instead:
- Create a new ADR that supersedes it
- Update the old ADR's status to "Superseded by ADR-XXX"
- Explain in the new ADR why the decision changed

## Organizing ADRs in Repositories

### File Structure Options

**Option 1: Flat directory**
```
docs/
└── adr/
    ├── 0001-use-postgresql.md
    ├── 0002-adopt-event-sourcing.md
    └── 0003-jwt-authentication.md
```

**Option 2: Single file (for smaller projects)**
```
ADR.md  # All decisions in one file
```

### Naming Convention

```
NNNN-short-title-with-hyphens.md

Examples:
0001-use-postgresql-for-persistence.md
0002-adopt-event-driven-architecture.md
```

## ADR Review Process

### Review Checklist

- [ ] Context clearly explains the problem
- [ ] Alternatives were considered
- [ ] Trade-offs are documented
- [ ] Consequences are realistic
- [ ] References support the decision
- [ ] Affected stakeholders consulted

### Lightweight Review Process

1. **Author** writes ADR in "Proposed" status
2. **Share** in team channel for async review (24-48h)
3. **Discuss** in team meeting if contested
4. **Accept** with consensus (or explicit decision-maker approval)
5. **Update** status to "Accepted"

## Writing Effective Context

### Good Context Includes

- **Problem statement**: What triggered the need for a decision?
- **Constraints**: Budget, timeline, team skills, existing systems
- **Forces**: Competing concerns that make the decision non-obvious
- **Alternatives considered**: What other options existed?

### Example: Good vs Bad Context

**Bad Context:**
> We need to choose a database.

**Good Context:**
> Our application requires storing user profiles with flexible schema (varying fields per user type) alongside transactional order data with strong consistency requirements. The team has PostgreSQL experience but limited NoSQL expertise. We expect 10K users in year one, growing to 100K by year three. Budget is limited, so managed services preferred over self-hosted.

## Writing Effective Consequences

### Categories

| Type | Description | Example |
|------|-------------|---------|
| **Positive** | Benefits gained | "Strong consistency for orders" |
| **Negative** | Trade-offs accepted | "Learning curve for JSONB" |
| **Neutral** | Observations | "Requires connection pooling at scale" |

### Be Specific

**Vague:** "Good performance"
**Specific:** "Sub-100ms query latency for typical read patterns"

**Vague:** "Some complexity"
**Specific:** "Requires implementing connection pooling before 1000 concurrent users"

## Trade-Off Documentation Template

Use this template when choosing between **competing architectures** where multiple valid approaches exist.

```markdown
## ADR-XXX: [Decision Title]

**Status**: Proposed | Accepted | Rejected | Superseded
**Date**: YYYY-MM-DD

### Context
[Describe the problem and why a decision is needed]

### Decision Drivers
- Factor 1
- Factor 2

### Options Considered

#### Option A: [Name]
**Pros**: [List]
**Cons**: [List]
**Cost**: [Implementation time, maintenance]

#### Option B: [Name]
**Pros**: [List]
**Cons**: [List]
**Cost**: [Implementation time, maintenance]

### Decision
**Chosen Option**: [Option X] - [Brief justification]

### Consequences
**Positive**: [Good outcomes]
**Negative**: [Trade-offs accepted]
**Mitigations**: [How to address negatives]

### When to Revisit
- [Trigger condition 1]
- [Trigger condition 2]
```

### Trade-Off Analysis Framework

When comparing options, quantify trade-offs where possible:

| Dimension | Option A | Option B | Winner |
|-----------|----------|----------|--------|
| **Latency** | 200ms | 800ms | A |
| **Implementation Time** | 20 hours | 28 hours | A |
| **Future Flexibility** | Low | High | B |

**Scoring**: Count wins per dimension. For MVP, prioritize implementation time and latency over future flexibility.
