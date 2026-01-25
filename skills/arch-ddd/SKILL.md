---
name: arch-ddd
description: Tactical DDD patterns for clean Python architecture including Domain Model, Repository, Service Layer, Unit of Work, and Aggregates. Use for backend architecture decisions, implementing data access layers, separating business logic from infrastructure, or reviewing code separation.
allowed-tools: Read, Grep, Glob
---

# Domain-Driven Architecture

Architectural patterns for building maintainable Python applications with clean separation between business logic and infrastructure.

## Core Principle

**"Behavior should drive storage, not the reverse."** Focus on what the system does, not just its data model.

## The Four Pillars

### 1. Domain Model Pattern
The heart of your application - pure business logic, no infrastructure dependencies.

- **Entities**: Objects with long-lived identity (User, Order)
- **Value Objects**: Immutable, defined by attributes (Money, Address)
- **Domain Services**: Logic spanning multiple entities

### 2. Repository Pattern
Abstraction over persistent storage with simple interface.

- Decouple domain from data access
- Enable testing with fake implementations
- Hide persistence complexity

### 3. Service Layer Pattern
Orchestrates use cases and defines application boundaries.

- Thin orchestration, not business logic
- Handles transaction boundaries
- Clear API for use cases

### 4. Unit of Work Pattern
Atomic operations and transaction lifecycle management.

- Explicit transaction boundaries
- Single entry point to repositories
- Ensures consistency

## Aggregate Pattern

Consistency boundaries - clusters of objects that must remain consistent together.

- One aggregate = one repository
- Modify one aggregate per transaction
- Reference others by ID only

## The Dependency Rule

Dependencies point inward:
```
Entrypoints → Service Layer → Domain Model
     ↓              ↓
  Adapters ← ← ← ← ←
```

## When to Apply

| Scenario | Pattern |
|----------|---------|
| Complex business rules | Domain Model |
| Multiple data sources | Repository |
| Multiple entry points | Service Layer |
| Transaction management | Unit of Work |
| Complex invariants | Aggregates |

See `reference.md` for detailed explanations and `examples.md` for implementations.
