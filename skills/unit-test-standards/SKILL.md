---
name: unit-test-standards
description: Python unit test standards including naming conventions (test__<what>__<expected>), behavioral testing patterns, coverage requirements (80% minimum), and tautological test detection. Use when reviewing tests, writing tests, or enforcing test quality. Trigger terms: unit test, test naming, test coverage, tautological test, behavioral test.
allowed-tools: Read, Grep, Glob
---

# Python Unit Test Standards

Standards for writing meaningful, maintainable tests that verify behavior.

## Test Naming Convention

```python
# Unit tests: test__<what>__<expected>
def test__batch_allocation__reduces_available_quantity():
    pass

# Integration tests: test__<component>__<behavior>
def test__repository__saves_and_retrieves_batch():
    pass

# E2E tests: test__<use_case>__<scenario>
def test__order_allocation__happy_path():
    pass
```

## Quality Criteria

| Good (Behavioral) | Bad (Tautological) |
|-------------------|-------------------|
| Test outcomes and state changes | Assert mocked return values |
| Use real objects where possible | Test that assignment works |
| Verify domain invariants | Tests with no assertions |
| Test error conditions explicitly | Test implementation details |

## Coverage Requirements

| Scope | Minimum | Target |
|-------|---------|--------|
| New code | 80% | 90% |
| Critical paths | 95% | 100% |
| Overall project | 70% | 80% |

## File Organization

```
tests/
├── unit/           # Fast, isolated (<100ms each)
├── integration/    # Database, API, external services
├── e2e/           # Full workflow tests
└── conftest.py    # Shared fixtures
```

## Tautological Test Detection

Tests that can't fail provide false confidence:

1. **Mock assertion** - Verifying mock returns what you told it to
2. **Assignment test** - Testing that `x = 5` results in `x == 5`
3. **Empty test** - No assertions or only `pass`
4. **Implementation test** - Testing HOW not WHAT

See `reference.md` for detection patterns and `examples.md` for comparisons.
