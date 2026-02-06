# Angular Reference

Detailed patterns and component library guidance for Angular 21+.

## Zoneless Change Detection (Default in v21)

```typescript
// No Zone.js needed - signals trigger updates automatically
bootstrapApplication(AppComponent, {
  providers: [
    // Zoneless is default in Angular 21+
    // Only add this if you need Zone.js for legacy code:
    // provideZoneChangeDetection()
  ]
});
```

**Benefits:**
- Smaller bundle (no Zone.js ~100KB)
- Predictable change detection
- Better debugging (no Zone.js stack traces)
- Signals automatically schedule updates

## Dependency Injection

```typescript
// Modern inject() function (preferred)
@Component({...})
export class UserService {
  private http = inject(HttpClient);
  private router = inject(Router);
}

// Constructor injection (still valid)
constructor(private http: HttpClient) {}
```

## HTTP Client Patterns

```typescript
// Functional interceptors (Angular 21+)
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = inject(AuthService).getToken();

  if (token) {
    req = req.clone({
      setHeaders: { Authorization: `Bearer ${token}` }
    });
  }

  return next(req);
};

// Registration
provideHttpClient(
  withInterceptors([authInterceptor, loggingInterceptor])
)
```

## Resource API (Async Data)

```typescript
// Signal-based async data loading
@Component({...})
export class UsersComponent {
  private usersService = inject(UsersService);

  searchQuery = signal('');

  usersResource = resource({
    request: () => ({ query: this.searchQuery() }),
    loader: async ({ request }) => {
      return this.usersService.search(request.query);
    }
  });

  // In template:
  // @if (usersResource.isLoading()) { ... }
  // @if (usersResource.hasValue()) { ... }
  // @if (usersResource.error()) { ... }
}
```

## Component Libraries Comparison

| Library | Cost | Components | Best For |
|---------|------|------------|----------|
| **PrimeNG** | Free (MIT) | 80+ | B2B dashboards, forms |
| **Kendo UI** | $1,028+/dev/year | 110+ | Enterprise, data grids |
| **Angular Material** | Free | ~40 | Material Design apps |

## Reactive Forms with Signals

```typescript
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';

@Component({
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
    <form [formGroup]="form" (ngSubmit)="onSubmit()">
      <input formControlName="email" />
      @if (form.controls.email.errors?.['required']) {
        <span class="error">Email is required</span>
      }
      <button type="submit" [disabled]="form.invalid">Submit</button>
    </form>
  `
})
export class LoginComponent {
  private fb = inject(FormBuilder);

  form = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]]
  });

  onSubmit() {
    if (this.form.valid) {
      console.log(this.form.value);
    }
  }
}
```

## Router Patterns

```typescript
// Route configuration
export const routes: Routes = [
  { path: '', component: HomeComponent },
  {
    path: 'dashboard',
    loadComponent: () => import('./dashboard/dashboard.component')
      .then(m => m.DashboardComponent),
    canActivate: [authGuard]
  },
  { path: '**', component: NotFoundComponent }
];

// Functional guard
export const authGuard: CanActivateFn = (route, state) => {
  const auth = inject(AuthService);
  const router = inject(Router);

  if (auth.isAuthenticated()) {
    return true;
  }

  return router.createUrlTree(['/login'], {
    queryParams: { returnUrl: state.url }
  });
};
```

## Error Handling

```typescript
// Global error handler
@Injectable()
export class GlobalErrorHandler implements ErrorHandler {
  private snackBar = inject(MatSnackBar);

  handleError(error: Error) {
    console.error('Unhandled error:', error);
    this.snackBar.open('An error occurred', 'Dismiss', {
      duration: 5000
    });
  }
}

// Provider
{ provide: ErrorHandler, useClass: GlobalErrorHandler }
```
