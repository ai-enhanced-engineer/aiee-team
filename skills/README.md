# Skills Contributor Guide

## What is a Skill?

A skill is a reusable knowledge module that agents load as context. Skills contain domain patterns, conventions, and reference material that make agents effective in specific areas.

Agents declare skills in their frontmatter via the `skills:` field. When an agent is summoned, its skills are automatically loaded alongside its own definition.

## File Structure

Each skill lives in its own directory under `skills/`:

```
skills/<skill-name>/
├── SKILL.md        # Required — frontmatter + core content
├── reference.md    # Optional — API patterns, checklists, lookup tables
└── examples.md     # Optional — annotated code samples
```

- **SKILL.md** is the entry point. It must exist.
- **reference.md** and **examples.md** are loaded alongside SKILL.md when present.

## SKILL.md Frontmatter

```yaml
---
name: frontend-angular              # Required — matches directory name
description: >-                     # Required — one-line summary ending with "Use for..." or "Use when..."
  Modern Angular 21+ patterns including signals, standalone components,
  zoneless change detection, and new control flow syntax. Use for Angular
  architecture decisions or implementing components with latest APIs.
trigger-terms: Angular 21+, signals  # Optional — terms that cause auto-loading
allowed-tools: Read, Grep, Glob      # Optional — tools the skill may use
---
```

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | Must match the directory name exactly |
| `description` | Yes | Keep under ~200 chars. End with a "Use for..." clause |
| `trigger-terms` | No | Comma-separated keywords for automatic skill loading |
| `allowed-tools` | No | Restrict which tools the skill can access |

## Adding a New Skill

1. **Create directory** — `skills/<skill-name>/`
2. **Add SKILL.md** — Include frontmatter and core content
3. **Add reference.md / examples.md** — If the skill benefits from lookup tables or code samples
4. **Wire it to an agent** — Add the skill name to the `skills:` field of the relevant agent(s)
5. **Update main README** — Add a row to the Skills table (keep alphabetical order)
6. **Submit a pull request**

## Conventions

- **Naming** — Use `kebab-case`. Group related skills with a prefix: `arch-*`, `frontend-*`, `gcp-*`, `ml-*`
- **Description** — Start with the domain topic, end with "Use for..." or "Use when..."
- **Size** — Keep SKILL.md focused. Move lengthy reference material to `reference.md`
- **No runtime code** — Skills are documentation, not executable scripts
