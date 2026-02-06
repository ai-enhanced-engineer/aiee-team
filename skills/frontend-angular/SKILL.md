---
name: frontend-angular
description: Modern Angular 21+ patterns including signals, standalone components, zoneless change detection, and new control flow syntax. Use for Angular architecture decisions or implementing components with latest APIs.
trigger-terms: Angular 21+, signals, standalone components, zoneless, control flow, @if, @for
---

# Angular Production Patterns

Production-ready patterns for Angular 21+ applications with zoneless change detection.

## Core Concepts

### Signal-Based Reactivity

```typescript
import { Component, signal, computed, effect } from '@angular/core';

@Component({
  selector: 'app-counter',
  standalone: true,
  template: `
    <button (click)="increment()">
      {{ count() }} × 2 = {{ doubled() }}
    </button>
  `
})
export class CounterComponent {
  count = signal(0);
  doubled = computed(() => this.count() * 2);

  constructor() {
    effect(() => console.log('Count changed:', this.count()));
  }

  increment() {
    this.count.update(n => n + 1);
  }
}
```

### Key APIs

| API | Purpose |
|-----|---------|
| `signal()` | Reactive state declaration |
| `computed()` | Derived values (auto-tracked) |
| `effect()` | Side effects on signal changes |
| `input()` | Component inputs (replaces @Input) |
| `output()` | Component outputs (replaces @Output) |
| `model()` | Two-way bindable signals |

## Modern Control Flow

```html
<!-- Conditionals -->
@if (isLoading()) {
  <app-spinner />
} @else if (hasError()) {
  <app-error [message]="error()" />
} @else {
  <app-content [data]="data()" />
}

<!-- Loops with tracking -->
@for (item of items(); track item.id) {
  <app-item [data]="item" />
} @empty {
  <p>No items found</p>
}

<!-- Switch -->
@switch (status()) {
  @case ('pending') { <app-pending /> }
  @case ('active') { <app-active /> }
  @default { <app-unknown /> }
}
```

## Standalone Architecture

```typescript
// No NgModules - components declare their dependencies
@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule, MetricsComponent],
  template: `...`
})
export class DashboardComponent {}

// Bootstrapping
bootstrapApplication(AppComponent, {
  providers: [
    provideRouter(routes),
    provideHttpClient(withInterceptors([authInterceptor]))
  ]
});
```

## Component I/O (Angular 21+)

```typescript
@Component({...})
export class UserCardComponent {
  // Input signal (required)
  user = input.required<User>();

  // Input with default
  showAvatar = input(true);

  // Output
  selected = output<User>();

  // Two-way binding
  isExpanded = model(false);

  onSelect() {
    this.selected.emit(this.user());
  }
}
```

## Performance Targets

| Metric | Target |
|--------|--------|
| LCP | < 2.5s |
| INP | < 200ms |
| CLS | < 0.1 |
| Initial Bundle | < 250KB |

## When NOT to Use Angular

- Simple interactivity → Vanilla JS
- Static marketing site → Astro/11ty
- < 100KB JS budget → Svelte or Web Components
- React ecosystem dependency → React

## Signal Testing Patterns

| Pattern | Use Case |
|---------|----------|
| PLATFORM_ID mocking | Prevent constructor side effects in SSR tests |
| WritableSignal with `.set()` | Control signal state without reassignment |
| NG0100 prevention | Initialize signals before `detectChanges()` |

## Signal-Based Service Pattern

Private writable signal → public readonly → update in `tap()` → component injects and reads:

```typescript
@Injectable({ providedIn: 'root' })
export class AnalyticsService {
  private _summary = signal<Summary | null>(null);
  readonly summary = this._summary.asReadonly();

  private _loading = signal(false);
  readonly loading = this._loading.asReadonly();

  getSummary() {
    this._loading.set(true);
    return this.http.get<Summary>('/api/analytics/summary').pipe(
      tap(data => {
        this._summary.set(data);
        this._loading.set(false);
      }),
      catchError(err => {
        this._loading.set(false);
        throw err;
      })
    );
  }
}
```

**Component usage:**
```typescript
@Component({...})
export class DashboardComponent {
  private analytics = inject(AnalyticsService);
  summary = this.analytics.summary;
  loading = this.analytics.loading;
}
```

**Pattern:** Matches AuthService pattern for consistency across services.

See `examples.md` for full testing code patterns.

See `reference.md` for component libraries.
