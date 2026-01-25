---
name: frontend-accessibility
description: Web accessibility patterns for WCAG 2.1 AA compliance including ARIA, keyboard navigation, screen reader support, and Svelte-specific implementations. Use for accessibility audits, a11y implementation, or inclusive design.
trigger-terms: accessibility audit, a11y, WCAG 2.1, keyboard navigation, screen reader, ARIA, accessible components, inclusive design, ADA compliance
allowed-tools: Read, Grep, Glob
---

# Frontend Accessibility Patterns

WCAG 2.1 AA compliance patterns for modern web applications.

## Core Principles (POUR)

| Principle | Description |
|-----------|-------------|
| **Perceivable** | Information presentable in ways users can perceive |
| **Operable** | Interface components operable by all users |
| **Understandable** | Information and operation understandable |
| **Robust** | Works with current and future technologies |

## Quick Reference

### Keyboard Navigation
- **Tab/Shift+Tab**: Navigate interactive elements
- **Enter/Space**: Activate buttons/links
- **Escape**: Close modals/dropdowns
- **Arrow keys**: Navigate lists/menus

### Color Contrast (WCAG AA)
- Normal text: **4.5:1** minimum
- Large text (18pt+): **3:1** minimum
- Interactive elements: **3:1** minimum

**Common Adjustments** (maintain hue, reduce HSL lightness ~20%):

| Original | Fixed | Use Case | Contrast |
|----------|-------|----------|----------|
| `#ef4444` | `#c53030` | Error red | 4.5:1 ✅ |
| `#f59e0b` | `#b45309` | Warning orange | 4.5:1 ✅ |
| `#10b981` | `#047857` | Success green | 4.5:1 ✅ |
| `#3b82f6` | `#1d4ed8` | Info blue | 4.5:1 ✅ |

**Rule**: For status colors on white background, check contrast at [webaim.org/resources/contrastchecker](https://webaim.org/resources/contrastchecker/)

### ARIA Essentials

```html
<!-- Landmarks -->
<header role="banner">
<nav role="navigation" aria-label="Main">
<main role="main">
<footer role="contentinfo">

<!-- Live regions (for dynamic content like chat) -->
<div role="status" aria-live="polite" aria-atomic="true">
  <!-- Screen reader announces changes -->
</div>

<!-- Accessible buttons -->
<button aria-label="Close dialog" aria-pressed="false">
```

### Focus Management
- Visible focus indicators (never `outline: none` without alternative)
- Trap focus in modals
- Return focus on modal close
- Manage focus on route changes

### Common Mistakes
- Missing `alt` on images
- Form inputs without labels
- Color as only indicator
- Mouse-only interactions
- Missing skip links
- Auto-playing media
- Conflicting visual states (e.g., "featured" and "selected" both using same visual indicator—use distinct patterns)

### Interactive Component Accessibility Checklist

For custom interactive components (tabs, accordions, selectors, toggles):

- [ ] **ARIA markup** - Correct role, aria-checked/selected/expanded
- [ ] **JavaScript announcements** - aria-live regions for state changes
- [ ] **Keyboard navigation** - Tab, Enter/Space, Arrow keys
- [ ] **Visual states** - Clear focus/selected/disabled indicators
- [ ] **Focus management** - Logical flow, no focus traps

See `reference.md` for WCAG criteria and `examples.md` for Svelte implementations.
