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

## Extensible Algorithm Design

Design algorithms for evolution using stable interfaces. MVP delivers value immediately while building ground truth for future ML phases.

**Evolution path:**
1. **MVP:** Deterministic algorithm (keyword matching, rule-based)
2. **Phase 2:** Statistical approach (TF-IDF, collaborative filtering)
3. **Phase 3:** ML/embeddings (neural networks, transformers)
4. **Phase 4:** LLM-powered (if needed)

**Interface pattern:**
```python
class Categorizer(Protocol):
    def categorize(self, text: str) -> tuple[str, float]:
        """Returns (category, confidence_score)"""
        ...
```

**Key principles:**
- MVP uses zero ML infrastructure (no model serving, no embeddings DB)
- Interface stays stable across phases (same input/output signature)
- Each phase is independently measurable (track accuracy improvement)
- Switch implementations via dependency injection, not rewrite

See `reference.md` for detailed patterns and `examples.md` for sample roadmaps.
