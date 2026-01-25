---
name: arch-decision-records
description: Architecture Decision Records (ADRs) for documenting significant technical decisions. Use for capturing decision context, rationale, consequences, and maintaining decision history.
---

# Architecture Decision Records

Lightweight documentation for architecturally significant decisions.

## Core Principle

> **"Document the why, not just the what."**

Code shows what was built; ADRs explain why it was built that way.

## What Makes a Decision "Architecturally Significant"?

| Criterion | Example |
|-----------|---------|
| Affects system structure | "Use event-driven architecture" |
| Hard to change later | "PostgreSQL as primary database" |
| Impacts non-functional requirements | "JWT for authentication" |
| Involves technology selection | "FastAPI over Flask" |
| Team disagrees or multiple valid options | Any contested decision |

## ADR Format

### Required Sections

| Section | Content |
|---------|---------|
| **Title** | `ADR-NNN: [Short descriptive title]` |
| **Status** | Proposed / Accepted / Deprecated / Superseded |
| **Context** | Why this decision is needed, constraints, forces |
| **Decision** | What was decided (clear, unambiguous) |
| **Consequences** | Positive, negative, and neutral outcomes |
| **References** | Links to research, docs, related ADRs |

## ADR Best Practices

1. **One decision per ADR** - Keep focused
2. **Never delete ADRs** - Mark as superseded instead
3. **Number sequentially** - Never reuse numbers
4. **Keep them short** - 1-2 pages maximum
5. **Write when deciding** - Not after the fact
6. **Link to research** - Traceability to evidence

## When NOT to Write an ADR

- Trivial decisions (naming conventions, formatting)
- Decisions already covered by team standards
- Temporary/experimental decisions
- Decisions with obvious single answers

## Status Lifecycle

```
Proposed → Accepted → [Deprecated | Superseded by ADR-XXX]
```

See `reference.md` for detailed guidance and `examples.md` for templates.
