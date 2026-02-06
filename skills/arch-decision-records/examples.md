# Architecture Decision Records Examples

Templates and real-world ADR examples.

## Blank ADR Template

```markdown
# ADR-NNN: [Short Title]

**Status**: Proposed | Accepted | Deprecated | Superseded by ADR-XXX
**Date**: YYYY-MM-DD
**Deciders**: [List of people involved]

## Context

[Describe the situation that requires a decision. Include:
- What problem are we solving?
- What constraints exist?
- What forces make this decision non-obvious?]

## Decision

[State the decision clearly and unambiguously.
Use active voice: "We will..." not "It was decided..."]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Neutral
- [Observation that's neither positive nor negative]

## Alternatives Considered

### [Alternative 1]
- Pros: [List]
- Cons: [List]
- Why rejected: [Reason]

### [Alternative 2]
- Pros: [List]
- Cons: [List]
- Why rejected: [Reason]

## References

- [Link to research synthesis]
- [Link to documentation]
- [Link to related ADR]
```

---

## Example: Technology Selection ADR

```markdown
# ADR-001: Use PostgreSQL for Primary Database

**Status**: Accepted
**Date**: 2024-01-15
**Deciders**: Alice (Tech Lead), Bob (Backend), Carol (DBA)

## Context

Our e-commerce platform needs to store:
- User profiles with varying fields per user type (customers, merchants, admins)
- Order transactions requiring ACID compliance
- Product catalog with full-text search

Constraints:
- Team has strong PostgreSQL experience (3+ years)
- Limited budget for managed services
- Expected load: 10K users year 1, 100K by year 3
- Need both relational queries and flexible schema

## Decision

We will use PostgreSQL as our primary database, leveraging:
- JSONB columns for flexible user profile fields
- Standard relational tables for orders and products
- Built-in full-text search with tsvector/tsquery

## Consequences

### Positive
- Single database technology reduces operational complexity
- Team can leverage existing PostgreSQL expertise
- JSONB provides schema flexibility without sacrificing transactions
- Strong ecosystem (pgvector for future ML features, PostGIS if needed)

### Negative
- JSONB queries can be slower than native document DBs for complex nesting
- Need to carefully design indexes for JSONB fields
- Full-text search less powerful than dedicated solutions (Elasticsearch)

### Neutral
- Will need connection pooling (PgBouncer) at ~500 concurrent connections
- Requires backup strategy planning

## Alternatives Considered

### MongoDB
- Pros: Native flexible schema, built-in sharding
- Cons: Team unfamiliar, weaker transactions, higher operational overhead
- Why rejected: Learning curve and transaction requirements

### PostgreSQL + Elasticsearch
- Pros: Best full-text search, separation of concerns
- Cons: Data synchronization complexity, two systems to maintain
- Why rejected: Over-engineering for current scale

## References

- [PostgreSQL JSONB Documentation](https://www.postgresql.org/docs/current/datatype-json.html)
```

---

## Example: Architecture Pattern ADR

```markdown
# ADR-002: Adopt Event-Driven Architecture for Order Processing

**Status**: Accepted
**Date**: 2024-01-20
**Deciders**: Alice (Tech Lead), David (Architect)

## Context

Order processing involves multiple downstream actions:
- Inventory update
- Payment processing
- Notification sending
- Analytics tracking

Current synchronous approach causes:
- Long response times (user waits for all operations)
- Tight coupling (failure in one system blocks order completion)
- Difficulty adding new downstream consumers

## Decision

We will adopt an event-driven architecture for order processing:
- Publish `OrderCreated` event after order is persisted
- Downstream services subscribe to events independently
- Use Redis Streams for event transport (migrate to Kafka at scale)

## Consequences

### Positive
- Order creation responds immediately (< 500ms)
- Downstream failures don't block order completion
- Easy to add new consumers without modifying publisher
- Natural audit log through event stream

### Negative
- Eventual consistency (inventory may be briefly out of sync)
- More complex debugging (distributed tracing needed)
- Need to handle duplicate event delivery (idempotency)

### Neutral
- Requires event schema versioning strategy
- Team needs to learn event-driven patterns

## Alternatives Considered

### Keep Synchronous
- Pros: Simpler mental model, immediate consistency
- Cons: Doesn't solve coupling or latency issues
- Why rejected: Current pain points will only worsen

### Saga Pattern with Orchestrator
- Pros: Centralized workflow control
- Cons: Orchestrator becomes bottleneck, single point of failure
- Why rejected: Choreography better fits our decoupled services

## References

- ADR-001 (database choice affects event storage)
```
