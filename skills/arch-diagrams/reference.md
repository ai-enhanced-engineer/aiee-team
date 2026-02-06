# Architecture Diagrams Reference

Complete syntax reference for architecture visualization.

## Mermaid Flowchart Reference

### Node Shapes

| Shape | Syntax | Use Case |
|-------|--------|----------|
| Rectangle | `[text]` | Services, components |
| Rounded | `(text)` | Processes, actions |
| Stadium | `([text])` | Start/end points |
| Database | `[(text)]` | Data stores |
| Circle | `((text))` | Events, triggers |
| Diamond | `{text}` | Decisions |

### Arrow Types

| Arrow | Syntax | Meaning |
|-------|--------|---------|
| Solid | `-->` | Direct call/dependency |
| Open | `---` | Association (no direction) |
| Dotted arrow | `-.->` | Async call |
| Thick | `==>` | Primary/critical path |

### Subgraphs

```mermaid
flowchart TB
    subgraph Frontend
        A[Widget]
        B[Dashboard]
    end

    subgraph Backend
        C[Gateway]
        D[Assistant]
    end

    subgraph Data
        E[(PostgreSQL)]
        F[(Redis)]
    end

    A --> C
    B --> C
    C --> D
    C --> E
    C --> F
```

## Sequence Diagram Reference

### Message Types

| Syntax | Type | Use Case |
|--------|------|----------|
| `->>` | Solid arrow | Synchronous request |
| `-->>` | Dashed arrow | Response or async |
| `-)` | Open arrow | Fire-and-forget |
| `-x` | X arrow | Failed/lost message |

### Control Flow

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server
    participant D as Database

    C->>S: Request

    alt Success
        S->>D: Query
        D-->>S: Results
        S-->>C: 200 OK
    else Not Found
        S-->>C: 404 Not Found
    end
```

> **Important**: The keyword `end` must match the case used to open the block.

### Loops

```mermaid
sequenceDiagram
    participant W as Widget
    participant G as Gateway

    loop Every 30s
        W->>G: Heartbeat
        G-->>W: Ack
    end
```

## C4 Model Reference

> **Note**: C4 diagrams in Mermaid are experimental.

### C4 Context (Level 1)

```mermaid
C4Context
    title System Context Diagram

    Person(user, "End User", "Primary user of the system")
    System(sys, "Our System", "The system being designed")
    System_Ext(ext, "External API", "Third-party service")

    Rel(user, sys, "Uses", "HTTPS")
    Rel(sys, ext, "Calls", "REST API")
```

### C4 Container (Level 2)

```mermaid
C4Container
    title Container Diagram

    Person(user, "User")

    System_Boundary(sb, "System") {
        Container(web, "Web App", "React", "User interface")
        Container(api, "API", "FastAPI", "Business logic")
        ContainerDb(db, "Database", "PostgreSQL", "Storage")
    }

    Rel(user, web, "Uses", "HTTPS")
    Rel(web, api, "Calls", "REST")
    Rel(api, db, "Reads/Writes", "SQL")
```

## ASCII Diagram Patterns

### Request Flow

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  Client  │───▶│  Widget  │───▶│ Gateway  │───▶│  Backend │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │               │               │               │
     │   Load Page   │               │               │
     │──────────────▶│               │               │
     │               │  WS Connect   │               │
     │               │──────────────▶│               │
     │               │               │   HTTP POST   │
     │               │               │──────────────▶│
     │               │               │◀──────────────│
     │               │◀──────────────│   Response    │
     │◀──────────────│   Display     │               │
```

### Decision Tree

```
                     ┌─────────────────────┐
                     │  Need Real-time?    │
                     └──────────┬──────────┘
                                │
                ┌───────────────┴───────────────┐
                │ Yes                       No  │
                ▼                               ▼
      ┌─────────────────┐             ┌─────────────────┐
      │   WebSocket     │             │   REST API      │
      │ (Bidirectional) │             │   (Polling OK)  │
      └─────────────────┘             └─────────────────┘
```

## Best Practices

### Readability

1. **Limit nodes** - Max 7-10 per diagram, split if needed
2. **Use consistent direction** - TD for hierarchy, LR for flows
3. **Group related items** - Subgraphs for logical boundaries
4. **Label all connections** - Protocol, format, or action

### Documentation

1. **Add context** - What decision does this support?
2. **Link to ADRs** - Reference architectural decisions
3. **Include legends** - Define abbreviations and symbols
