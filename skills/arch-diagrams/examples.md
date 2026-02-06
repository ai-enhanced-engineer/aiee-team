# Architecture Diagrams Examples

Annotated examples for common architecture visualization scenarios.

## Microservice Communication Flow

Shows service-to-service communication with async messaging.

```mermaid
flowchart LR
    subgraph Public
        A[API Gateway]
    end

    subgraph Services
        B[User Service]
        C[Order Service]
        D[Notification Service]
    end

    subgraph Data
        E[(PostgreSQL)]
        F[(Redis Cache)]
        G>Message Queue]
    end

    A --> B
    A --> C
    B --> E
    B --> F
    C --> E
    C -.-> G
    G -.-> D
```

**Why this works:**
- Left-to-right flow mirrors request direction
- Subgraphs group by deployment boundary
- Dotted arrows distinguish async from sync calls

## Authentication Sequence

Shows the OAuth2 authorization code flow with token refresh.

```mermaid
sequenceDiagram
    participant U as User
    participant App as Web App
    participant Auth as Auth Server
    participant API as Resource API

    U->>App: Login request
    App->>Auth: Authorization request
    Auth-->>U: Login prompt
    U->>Auth: Credentials
    Auth-->>App: Authorization code

    App->>Auth: Exchange code for tokens
    Auth-->>App: Access token + Refresh token

    App->>API: Request + Access token
    API-->>App: Protected resource

    Note over App,Auth: Token expires after 15 min

    App->>Auth: Refresh token
    Auth-->>App: New access token
```

**Why this works:**
- Participants ordered left-to-right by trust level
- Notes clarify timing constraints
- Response arrows use dashed style

## System Context (C4 Level 1)

High-level view showing the system and its external dependencies.

```mermaid
C4Context
    title E-Commerce Platform - System Context

    Person(customer, "Customer", "Places orders and tracks deliveries")
    Person(admin, "Admin", "Manages products and orders")

    System(platform, "E-Commerce Platform", "Handles product catalog, orders, and payments")

    System_Ext(payment, "Payment Gateway", "Processes credit card payments")
    System_Ext(shipping, "Shipping Provider", "Calculates rates and tracks packages")
    System_Ext(email, "Email Service", "Sends transactional emails")

    Rel(customer, platform, "Browses and purchases", "HTTPS")
    Rel(admin, platform, "Manages", "HTTPS")
    Rel(platform, payment, "Processes payments", "REST API")
    Rel(platform, shipping, "Ships orders", "REST API")
    Rel(platform, email, "Sends notifications", "SMTP")
```

**Why this works:**
- Focuses on what the system does, not how
- External systems clearly marked with `System_Ext`
- Relationships include protocol

## Decision Matrix

Use tables when comparing options across multiple criteria.

```markdown
| Criteria (weight) | PostgreSQL | DynamoDB | MongoDB |
|--------------------|-----------|----------|---------|
| ACID compliance (5) | 5 (25) | 2 (10) | 3 (15) |
| Horizontal scale (3) | 2 (6) | 5 (15) | 4 (12) |
| Query flexibility (4) | 5 (20) | 2 (8) | 4 (16) |
| Ops complexity (3) | 4 (12) | 5 (15) | 3 (9) |
| **Total** | **63** | **48** | **52** |
```

**Why this works:**
- Weighted scoring makes trade-offs explicit
- Supports ADR decisions with quantified reasoning

## ASCII Deployment Diagram

Quick sketch for documentation or chat when Mermaid isn't available.

```
┌─────────────────────────────────────────────────┐
│                  GCP Project                     │
│                                                  │
│  ┌──────────────┐       ┌──────────────────┐    │
│  │  Cloud Run    │       │  Cloud SQL       │    │
│  │  ┌─────────┐ │       │  ┌────────────┐  │    │
│  │  │ API     │─┼───────┼─▶│ PostgreSQL │  │    │
│  │  └─────────┘ │       │  └────────────┘  │    │
│  │  ┌─────────┐ │       └──────────────────┘    │
│  │  │ Worker  │─┼──┐                             │
│  │  └─────────┘ │  │    ┌──────────────────┐    │
│  └──────────────┘  │    │  Memorystore     │    │
│                     └────┼─▶│ Redis        │    │
│                          │  └──────────────┘    │
│                          └──────────────────┘    │
└─────────────────────────────────────────────────┘
```

**Why this works:**
- No tooling required, works in any text editor
- Box-drawing characters create clean boundaries
- Arrows show data flow direction
