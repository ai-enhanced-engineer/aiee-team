# Angular Examples

Production-ready component implementations for Angular 21+.

## Dashboard Metrics Component

```typescript
import { Component, input, computed } from '@angular/core';
import { DecimalPipe, PercentPipe } from '@angular/common';

interface Metric {
  label: string;
  value: number;
  format: 'number' | 'currency' | 'percent';
  trend: 'up' | 'down' | 'stable';
}

@Component({
  selector: 'app-metrics-widget',
  standalone: true,
  imports: [DecimalPipe, PercentPipe],
  template: `
    <div class="metrics-grid" role="region" aria-labelledby="metrics-heading">
      <h2 id="metrics-heading" class="sr-only">Key Metrics</h2>

      @for (metric of metrics(); track metric.label) {
        <article
          class="metric-card"
          [attr.aria-label]="metric.label + ': ' + formatValue(metric)">
          <span class="label">{{ metric.label }}</span>
          <span class="value">{{ formatValue(metric) }}</span>
          <span class="trend" [class]="metric.trend">
            @switch (metric.trend) {
              @case ('up') { ↑ }
              @case ('down') { ↓ }
              @default { → }
            }
          </span>
        </article>
      }
    </div>
  `,
  styles: [`
    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
    }
    .metric-card {
      padding: 1.5rem;
      border-radius: 8px;
      background: var(--surface-card);
      box-shadow: var(--shadow-sm);
    }
    .trend.up { color: var(--green-500); }
    .trend.down { color: var(--red-500); }
    .sr-only {
      position: absolute;
      width: 1px;
      height: 1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
    }
  `]
})
export class MetricsWidgetComponent {
  metrics = input.required<Metric[]>();

  formatValue(metric: Metric): string {
    switch (metric.format) {
      case 'currency':
        return new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: 'USD'
        }).format(metric.value);
      case 'percent':
        return `${(metric.value * 100).toFixed(1)}%`;
      default:
        return metric.value.toLocaleString();
    }
  }
}
```
