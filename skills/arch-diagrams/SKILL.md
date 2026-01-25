---
name: arch-diagrams
description: Architecture visualization patterns using Mermaid and ASCII diagrams. Use for service flows, sequence diagrams, C4 models, decision matrices, or expressing architectural ideas visually. Trigger terms: diagram, flowchart, sequence diagram, architecture visualization, C4 model.
allowed-tools: Read, Grep, Glob
---

# Architecture Diagrams

Patterns for expressing architectural ideas visually.

## Diagram Selection

| Need to Show | Use | Tool |
|--------------|-----|------|
| Service dependencies | Flowchart | Mermaid |
| Request/response timing | Sequence | Mermaid |
| System boundaries | C4 Context | Mermaid |
| Internal architecture | C4 Container | Mermaid |
| Quick inline sketch | ASCII Box | Text |
| Option comparison | Decision Matrix | Table |

## Quick Syntax Reference

**Mermaid Flowchart:** `flowchart TD` → `A[Node] --> B[Node]`

**Mermaid Sequence:** `sequenceDiagram` → `A->>B: Message`

**C4 Model:** `C4Context` or `C4Container` → `Person()`, `System()`, `Container()`

**ASCII Box:** `┌───┐ │ │ └───┘` with `───▶` arrows

## Best Practices

1. **Start simple** - ASCII first, Mermaid if complexity warrants
2. **Label everything** - Unlabeled arrows are ambiguous
3. **Show data flow** - Arrows indicate who initiates
4. **Group related** - Use subgraphs for logical boundaries

See `reference.md` for complete syntax, examples, and advanced patterns.
