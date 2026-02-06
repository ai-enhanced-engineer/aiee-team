# Frontend Accessibility Reference

## WCAG 2.1 Level AA Success Criteria

### Perceivable

| Criterion | Requirement |
|-----------|-------------|
| **1.1.1 Non-text Content** | All images, icons have text alternatives |
| **1.2.1-5 Time-based Media** | Captions, audio descriptions for video |
| **1.3.1 Info and Relationships** | Semantic HTML, proper headings hierarchy |
| **1.3.2 Meaningful Sequence** | Reading order matches visual order |
| **1.3.3 Sensory Characteristics** | Don't rely solely on shape, size, location |
| **1.3.4 Orientation** | Support both portrait and landscape |
| **1.3.5 Identify Input Purpose** | Use autocomplete for common fields |
| **1.4.1 Use of Color** | Color not sole means of conveying info |
| **1.4.3 Contrast (Minimum)** | 4.5:1 for text, 3:1 for large text |
| **1.4.4 Resize Text** | 200% zoom without loss of content |
| **1.4.5 Images of Text** | Use real text, not images of text |
| **1.4.10 Reflow** | No horizontal scroll at 320px width |
| **1.4.11 Non-text Contrast** | 3:1 for UI components and graphics |
| **1.4.12 Text Spacing** | Content readable with increased spacing |
| **1.4.13 Content on Hover/Focus** | Dismissible, hoverable, persistent |

### Operable

| Criterion | Requirement |
|-----------|-------------|
| **2.1.1 Keyboard** | All functionality keyboard accessible |
| **2.1.2 No Keyboard Trap** | Focus can move away from any element |
| **2.1.4 Character Key Shortcuts** | Single-key shortcuts can be disabled |
| **2.2.1 Timing Adjustable** | Time limits can be extended |
| **2.2.2 Pause, Stop, Hide** | Moving content controllable |
| **2.3.1 Three Flashes** | No content flashes more than 3x/second |
| **2.4.1 Bypass Blocks** | Skip navigation links available |
| **2.4.2 Page Titled** | Pages have descriptive titles |
| **2.4.3 Focus Order** | Logical, predictable focus sequence |
| **2.4.4 Link Purpose** | Link text describes destination |
| **2.4.5 Multiple Ways** | Multiple ways to find pages |
| **2.4.6 Headings and Labels** | Descriptive headings and labels |
| **2.4.7 Focus Visible** | Keyboard focus indicator visible |

### Understandable

| Criterion | Requirement |
|-----------|-------------|
| **3.1.1 Language of Page** | Page lang attribute set |
| **3.1.2 Language of Parts** | Lang attribute on foreign text |
| **3.2.1 On Focus** | No context change on focus |
| **3.2.2 On Input** | No unexpected context change on input |
| **3.2.3 Consistent Navigation** | Navigation consistent across pages |
| **3.2.4 Consistent Identification** | Same function = same label |
| **3.3.1 Error Identification** | Errors clearly identified and described |
| **3.3.2 Labels or Instructions** | Form inputs have labels |
| **3.3.3 Error Suggestion** | Suggest corrections for errors |
| **3.3.4 Error Prevention** | Confirm, review, reversible for important actions |

### Robust

| Criterion | Requirement |
|-----------|-------------|
| **4.1.1 Parsing** | Valid HTML (no duplicate IDs) |
| **4.1.2 Name, Role, Value** | Custom controls have accessible name/role |
| **4.1.3 Status Messages** | Status updates announced without focus |

---

## Testing Tools

### Automated Testing

| Tool | Use For |
|------|---------|
| **axe DevTools** | Browser extension, CI integration |
| **Lighthouse** | Chrome DevTools, general audit |
| **WAVE** | Browser extension, visual feedback |
| **eslint-plugin-jsx-a11y** | Linting for React/JSX (adaptable patterns) |

### Manual Testing

| Tool | Use For |
|------|---------|
| **Keyboard only** | Tab through entire page, test all interactions |
| **Screen readers** | VoiceOver (Mac), NVDA (Windows), Orca (Linux) |
| **Color contrast checker** | WebAIM contrast checker |
| **Browser zoom** | Test at 200% zoom |

### Screen Reader Testing Guide

```bash
# VoiceOver (Mac)
Cmd + F5           # Toggle VoiceOver on/off
Ctrl + Option + →  # Navigate forward
Ctrl + Option + ←  # Navigate backward
Ctrl + Option + Space  # Activate element

# NVDA (Windows)
Insert + Space     # Toggle forms/browse mode
Tab               # Navigate form controls
Arrow keys        # Read content
Enter             # Activate links/buttons
```

---

## ARIA Roles Reference

### Landmark Roles

```html
<header role="banner">           <!-- Page header, once per page -->
<nav role="navigation">          <!-- Navigation, use aria-label for multiple -->
<main role="main">               <!-- Main content, once per page -->
<aside role="complementary">     <!-- Sidebar, related content -->
<footer role="contentinfo">      <!-- Page footer, once per page -->
<form role="search">             <!-- Search form -->
```

### Widget Roles

```html
<div role="dialog" aria-modal="true">     <!-- Modal dialog -->
<div role="alertdialog">                  <!-- Alert requiring response -->
<div role="alert">                        <!-- Important, time-sensitive -->
<div role="status">                       <!-- Status update -->
<div role="tablist">                      <!-- Tab container -->
<button role="tab" aria-selected="true">  <!-- Tab button -->
<div role="tabpanel">                     <!-- Tab content -->
<ul role="listbox">                       <!-- Selectable list -->
<li role="option" aria-selected="false">  <!-- List option -->
```

### Live Region Attributes

```html
<!-- Polite: Announces when user idle -->
<div aria-live="polite" aria-atomic="true">
  New message received
</div>

<!-- Assertive: Interrupts immediately (use for errors) -->
<div aria-live="assertive" role="alert">
  Connection lost
</div>

<!-- Atomic: Announce entire region vs just changes -->
<div aria-live="polite" aria-atomic="true">
  3 items in cart  <!-- Reads "3 items in cart", not just "3" -->
</div>
```

---

## Color Contrast

### Calculating Contrast Ratio

```
Contrast Ratio = (L1 + 0.05) / (L2 + 0.05)

Where L1 = lighter color luminance, L2 = darker color luminance
```

### Common Safe Combinations

| Background | Text | Ratio |
|------------|------|-------|
| `#FFFFFF` | `#000000` | 21:1 |
| `#FFFFFF` | `#595959` | 7:1 |
| `#FFFFFF` | `#767676` | 4.54:1 (minimum) |
| `#FFFFFF` | `#949494` | 2.94:1 (fails) |
| `#1a1a1a` | `#FFFFFF` | 17.4:1 |
| `#007bff` | `#FFFFFF` | 4.5:1 (barely) |

### Tools

- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Colour Contrast Analyser](https://www.tpgi.com/color-contrast-checker/)
- Chrome DevTools: Inspect element → Color picker shows contrast

---

## Focus Management Patterns

### Focus Trap (for modals)

```typescript
function trapFocus(element: HTMLElement) {
  const focusableElements = element.querySelectorAll(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );
  const first = focusableElements[0] as HTMLElement;
  const last = focusableElements[focusableElements.length - 1] as HTMLElement;

  element.addEventListener('keydown', (e) => {
    if (e.key !== 'Tab') return;

    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  });

  first.focus();
}
```

### Return Focus on Close

```typescript
let previouslyFocused: HTMLElement | null = null;

function openModal() {
  previouslyFocused = document.activeElement as HTMLElement;
  modal.showModal();
  trapFocus(modal);
}

function closeModal() {
  modal.close();
  previouslyFocused?.focus();
}
```

---

## Shadow DOM Accessibility

### Challenges

1. **ARIA references can't cross shadow boundary** - `aria-labelledby` IDs must be in same DOM tree
2. **Focus delegation** - Use `delegatesFocus: true` in attachShadow
3. **Form participation** - Custom elements need ElementInternals for form association

### Solutions

```typescript
// Enable focus delegation
this.attachShadow({ mode: 'open', delegatesFocus: true });

// Use aria-label instead of aria-labelledby for cross-boundary
<button aria-label="Send message">  // Works in Shadow DOM
<button aria-labelledby="label-id"> // Won't find ID outside shadow

// Form association with ElementInternals
class MyInput extends HTMLElement {
  static formAssociated = true;
  #internals: ElementInternals;

  constructor() {
    super();
    this.#internals = this.attachInternals();
  }

  get value() { return this.#internals.value; }
  set value(v) { this.#internals.setFormValue(v); }
}
```
