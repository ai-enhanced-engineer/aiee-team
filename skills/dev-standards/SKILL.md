---
name: dev-standards
description: Development standards for Python projects including code style, git conventions, testing patterns, and validation requirements. Use when writing code, reviewing PRs, or making commits. Loaded by all implementation agents.
allowed-tools: Read, Grep, Glob
---

# Development Standards

Core behavioral rules for code generation and project maintenance.

## Core Rules

1. **Do what's asked** - Nothing more, nothing less
2. **Prefer editing** - Always edit existing files over creating new ones
3. **No unnecessary files** - Never proactively create documentation unless explicitly requested
4. **No backwards compatibility assumptions** - Unless specifically instructed

## Decision Priority Order

When making implementation decisions:

| Priority | Focus | Question |
|----------|-------|----------|
| 1 | Business requirements | What problem are we solving? |
| 2 | Domain model integrity | Does this preserve our invariants? |
| 3 | Existing patterns | Consistency over perfection |
| 4 | Project conventions | Check project's CLAUDE.md |
| 5 | Team standards | As documented in configs/docs |
| 6 | Industry best practices | Only if no project precedent |

## Before Making Changes

- [ ] Searched for existing implementations?
- [ ] Will this break existing functionality?
- [ ] Following the project's patterns?
- [ ] Checked the test suite?
- [ ] Is this the minimal change needed?

## Critical Reminders

1. **Never assume dependencies exist** - Check `pyproject.toml` first
2. **Test modifications immediately** - Don't accumulate changes
3. **Read existing code patterns first** - Match the project's style
4. **Domain logic stays pure** - No framework dependencies in domain model

## Before Any Commit (Non-negotiable)

**Run `make validate-branch` before ANY commit** - No exceptions.

Additional requirements:
- Do not add claude signatures to commits and PRs
- Do not commit until confirmed by user

See `reference.md` for Git guidelines, test naming conventions, and validation requirements.
