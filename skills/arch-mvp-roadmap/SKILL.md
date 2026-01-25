---
name: arch-mvp-roadmap
description: MVP definition, MoSCoW prioritization, and phased delivery planning. Use for scoping minimum viable products, ordering features by value and dependency, or creating implementation roadmaps.
---

# MVP & Roadmap Planning

Patterns for defining what to build first and in what order.

## Core Principle

> **"Build the smallest thing that proves value."**

An MVP is not a half-built product—it's a complete vertical slice that validates assumptions.

## MoSCoW Prioritization

| Priority | Definition | Criteria |
|----------|------------|----------|
| **Must Have** | System doesn't function without | Core journey incomplete, no workarounds |
| **Should Have** | Important but not blocking | Workarounds exist, high value |
| **Could Have** | Nice to have | Enhances experience, low priority |
| **Won't Have** | Explicitly out of scope | Prevents scope creep, document for later |

## MVP Scoping Checklist

- [ ] Single complete user journey end-to-end
- [ ] Validates core assumption/hypothesis
- [ ] Deployable and demonstrable
- [ ] Measurable success criteria defined
- [ ] No features without corresponding tests

## Phased Delivery Pattern

Each phase should:
1. Build on previous phase (not parallel development)
2. Be independently deployable
3. Have clear success criteria
4. Include tests for new functionality

## Dependency Ordering

Order features by:

| Factor | Question |
|--------|----------|
| **Technical** | What must exist first? |
| **Value** | What provides most value soonest? |
| **Risk** | What validates riskiest assumptions? |
| **Learning** | What teaches us most about the domain? |

## Roadmap Template

| Phase | Features | Success Criteria | Dependencies |
|-------|----------|------------------|--------------|
| MVP | [Must-haves] | [Measurable outcomes] | None |
| Phase 2 | [Should-haves] | [Measurable outcomes] | MVP complete |
| Phase 3 | [Could-haves] | [Measurable outcomes] | Phase 2 complete |

See `reference.md` for detailed patterns and `examples.md` for sample roadmaps.
