# Angular Testing Examples

Complete test suites for Angular 21+ components.

## Dashboard Component Test Suite

```typescript
import { TestBed, ComponentFixture } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { DashboardComponent } from './dashboard.component';
import { DashboardService } from './dashboard.service';

describe('DashboardComponent', () => {
  let fixture: ComponentFixture<DashboardComponent>;
  let component: DashboardComponent;
  let httpMock: HttpTestingController;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DashboardComponent, HttpClientTestingModule]
    }).compileComponents();

    fixture = TestBed.createComponent(DashboardComponent);
    component = fixture.componentInstance;
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  describe('initialization', () => {
    it('should show loading state initially', () => {
      expect(component.isLoading()).toBe(true);
      expect(fixture.nativeElement.querySelector('.loading')).toBeTruthy();
    });

    it('should load metrics on init', async () => {
      fixture.detectChanges(); // Triggers ngOnInit

      const req = httpMock.expectOne('/api/metrics');
      req.flush({
        revenue: 50000,
        users: 1200,
        conversion: 0.045
      });

      TestBed.flushEffects();
      fixture.detectChanges();

      expect(component.isLoading()).toBe(false);
      expect(component.metrics()).toEqual({
        revenue: 50000,
        users: 1200,
        conversion: 0.045
      });
    });
  });

  describe('computed values', () => {
    it('should format currency correctly', () => {
      component.metrics.set({ revenue: 50000, users: 0, conversion: 0 });
      TestBed.flushEffects();

      expect(component.formattedRevenue()).toBe('$50,000.00');
    });

    it('should calculate percentage correctly', () => {
      component.metrics.set({ revenue: 0, users: 0, conversion: 0.0456 });
      TestBed.flushEffects();

      expect(component.formattedConversion()).toBe('4.6%');
    });
  });

  describe('user interactions', () => {
    it('should refresh data when button clicked', async () => {
      // Initial load
      fixture.detectChanges();
      httpMock.expectOne('/api/metrics').flush({ revenue: 100 });

      // Click refresh
      const refreshBtn = fixture.nativeElement.querySelector('[data-testid="refresh"]');
      refreshBtn.click();

      const req = httpMock.expectOne('/api/metrics');
      req.flush({ revenue: 200 });
      TestBed.flushEffects();

      expect(component.metrics()?.revenue).toBe(200);
    });
  });

  describe('error handling', () => {
    it('should display error message on API failure', async () => {
      fixture.detectChanges();

      const req = httpMock.expectOne('/api/metrics');
      req.flush('Server error', { status: 500, statusText: 'Internal Server Error' });

      TestBed.flushEffects();
      fixture.detectChanges();

      expect(component.error()).toBeTruthy();
      expect(fixture.nativeElement.querySelector('.error')).toBeTruthy();
    });
  });
});
```
