# Agents Contributor Guide

## What is an Agent?

An agent is a domain specialist with built-in expertise. Each agent definition describes a role, its capabilities, and the skills that provide its knowledge base.

## How Agents Work

Agents are summoned by the orchestrator or explicitly by the user. When an agent activates, Claude Code loads its definition and all skills listed in its `skills:` field as context.

```
User request → Orchestrator selects agent → Agent + skills loaded → Task executed
```

## Agent Frontmatter

```yaml
---
name: aiee-backend-engineer          # Required — unique agent identifier
description: >-                      # Required — one-line summary with "Call for..." guidance
  Python backend engineer for API design, database modeling, and system
  integration. Call for FastAPI architecture, PostgreSQL schema design,
  DDD patterns, async programming, or service layer decisions.
model: sonnet                        # Optional — model preference (sonnet, opus, haiku)
color: green                         # Optional — display color in agent listings
skills: arch-ddd, arch-events, dev-standards  # Optional — comma-separated skill names
---
```

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | Must use `aiee-` prefix |
| `description` | Yes | Include "Call for..." to help the orchestrator route tasks |
| `model` | No | Defaults to the orchestrator's model if omitted |
| `color` | No | Visual hint in CLI agent listings |
| `skills` | No | Comma-separated list of skill directory names |

## Adding a New Agent

1. **Create file** — `agents/aiee-<role>.md`
2. **Add frontmatter** — Include `name`, `description`, and relevant `skills`
3. **Write body sections**:
   - **Expertise Scope** — Technologies and patterns the agent knows
   - **When to Call** — Specific scenarios where this agent adds value
   - **NOT For** — Out-of-scope tasks (helps the orchestrator avoid misrouting)
4. **Update main README** — Add a row to the Team Members table
5. **Submit a pull request**

## Conventions

- **Naming** — All agents use the `aiee-` prefix (e.g., `aiee-security-engineer`)
- **Description** — Include "Call for..." to guide automatic routing
- **NOT For section** — Explicitly list what the agent should not handle
- **Skills** — Only reference skills that exist in `skills/`. Verify names match directory names
