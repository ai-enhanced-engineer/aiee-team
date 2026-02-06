---
name: testing-angular
description: Angular 21+ testing patterns with Vitest, signal component testing, and Playwright E2E. Use for writing unit tests, integration tests, or E2E tests for Angular applications. Trigger terms: Angular testing, Vitest, Jasmine, Karma, Playwright E2E, signal testing.
---

# Angular Testing Patterns

Testing fundamentals for Angular 21+ applications with Vitest (Karma is deprecated).

## Testing Stack (Angular 21+)

| Tool | Purpose | Status |
|------|---------|--------|
| **Vitest** | Unit/integration tests | Default in v21 |
| **Jasmine** | Test syntax | Still supported |
| **Playwright** | E2E testing | Recommended |
| **Testing Library** | Component queries | Optional |

## Quick Setup

```bash
# New project (Vitest is default)
ng new my-app

# Migrate existing project from Karma
ng generate @angular/core:migrate-to-vitest
```

## Signal Component Testing

```typescript
import { TestBed } from '@angular/core/testing';
import { CounterComponent } from './counter.component';

describe('CounterComponent', () => {
  it('should update signal and computed values', async () => {
    const fixture = TestBed.createComponent(CounterComponent);
    const component = fixture.componentInstance;

    // Initial state
    expect(component.count()).toBe(0);
    expect(component.doubled()).toBe(0);

    // Update signal
    component.count.set(5);

    // CRITICAL: Flush effects for signal updates
    TestBed.flushEffects();

    expect(component.count()).toBe(5);
    expect(component.doubled()).toBe(10);
  });
});
```

## Key Testing APIs

| API | Purpose |
|-----|---------|
| `TestBed.flushEffects()` | Flush signal effects (NEW in v21) |
| `fixture.detectChanges()` | Trigger change detection |
| `fixture.whenStable()` | Wait for async operations |
| `fakeAsync() / tick()` | Control time in tests |

## Test File Naming

```
component.spec.ts     # Unit tests
component.test.ts     # Alternative (Vitest style)
component.e2e.ts      # E2E tests (Playwright)
```

## When to Use Each Test Type

| Scenario | Test Type | Tool |
|----------|-----------|------|
| Signal logic | Unit | Vitest |
| Component rendering | Integration | Vitest + TestBed |
| User interactions | Integration | Vitest + Testing Library |
| Full user flows | E2E | Playwright |
| Visual regression | E2E | Playwright screenshots |

See `reference.md` for detailed patterns and `examples.md` for complete test suites.
