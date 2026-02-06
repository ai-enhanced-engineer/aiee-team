# Frontend Accessibility Examples

Svelte 5 accessible component patterns.

## Accessible Button

```svelte
<script lang="ts">
  interface Props {
    onclick: () => void;
    disabled?: boolean;
    loading?: boolean;
    label: string;
    children: any;
  }

  let { onclick, disabled = false, loading = false, label, children }: Props = $props();
</script>

<button
  {onclick}
  disabled={disabled || loading}
  aria-label={label}
  aria-busy={loading}
  aria-disabled={disabled}
>
  {#if loading}
    <span class="sr-only">Loading...</span>
    <span aria-hidden="true" class="spinner"></span>
  {:else}
    {@render children()}
  {/if}
</button>

<style>
  .sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
  }
</style>
```

## Accessible Modal

```svelte
<script lang="ts">
  import { tick } from 'svelte';

  interface Props {
    open: boolean;
    title: string;
    onclose: () => void;
    children: any;
  }

  let { open = $bindable(false), title, onclose, children }: Props = $props();

  let dialogRef: HTMLDialogElement;
  let previouslyFocused: HTMLElement | null = null;

  $effect(() => {
    if (open) {
      previouslyFocused = document.activeElement as HTMLElement;
      dialogRef?.showModal();
    } else {
      dialogRef?.close();
      previouslyFocused?.focus();
    }
  });

  function handleKeydown(e: KeyboardEvent) {
    if (e.key === 'Escape') {
      e.preventDefault();
      onclose();
    }
  }

  function handleBackdropClick(e: MouseEvent) {
    if (e.target === dialogRef) {
      onclose();
    }
  }
</script>

<dialog
  bind:this={dialogRef}
  onkeydown={handleKeydown}
  onclick={handleBackdropClick}
  aria-labelledby="dialog-title"
  aria-modal="true"
>
  <header>
    <h2 id="dialog-title">{title}</h2>
    <button
      onclick={onclose}
      aria-label="Close dialog"
      class="close-btn"
    >
      <span aria-hidden="true">&times;</span>
    </button>
  </header>
  <div class="content">
    {@render children()}
  </div>
</dialog>

<style>
  dialog::backdrop {
    background: rgba(0, 0, 0, 0.5);
  }

  dialog {
    border: none;
    border-radius: 8px;
    padding: 0;
    max-width: 500px;
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    border-bottom: 1px solid #eee;
  }

  .close-btn {
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
    padding: 0.25rem;
  }

  .close-btn:focus-visible {
    outline: 2px solid #007bff;
    outline-offset: 2px;
  }
</style>
```

## Accessible Form Input

```svelte
<script lang="ts">
  interface Props {
    id: string;
    label: string;
    type?: string;
    value: string;
    error?: string;
    hint?: string;
    required?: boolean;
  }

  let {
    id,
    label,
    type = 'text',
    value = $bindable(''),
    error,
    hint,
    required = false
  }: Props = $props();

  let describedBy = $derived(
    [error ? `${id}-error` : null, hint ? `${id}-hint` : null]
      .filter(Boolean)
      .join(' ') || undefined
  );
</script>

<div class="field" class:has-error={error}>
  <label for={id}>
    {label}
    {#if required}
      <span aria-hidden="true" class="required">*</span>
      <span class="sr-only">(required)</span>
    {/if}
  </label>

  <input
    {id}
    {type}
    bind:value
    {required}
    aria-invalid={error ? 'true' : undefined}
    aria-describedby={describedBy}
  />

  {#if hint && !error}
    <span id="{id}-hint" class="hint">{hint}</span>
  {/if}

  {#if error}
    <span id="{id}-error" class="error" role="alert">
      {error}
    </span>
  {/if}
</div>

<style>
  .field {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .required {
    color: #dc3545;
  }

  .has-error input {
    border-color: #dc3545;
  }

  .error {
    color: #dc3545;
    font-size: 0.875rem;
  }

  .hint {
    color: #6c757d;
    font-size: 0.875rem;
  }

  .sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
  }
</style>
```

## Skip Link

```svelte
<script lang="ts">
  // Skip link allows keyboard users to jump directly to main content
  interface Props {
    targetId: string;
    label?: string;
  }

  let { targetId, label = 'Skip to main content' }: Props = $props();
</script>

<a href="#{targetId}" class="skip-link">
  {label}
</a>

<style>
  .skip-link {
    position: absolute;
    top: -40px;
    left: 0;
    padding: 0.5rem 1rem;
    background: #007bff;
    color: white;
    text-decoration: none;
    z-index: 100;
  }

  .skip-link:focus {
    top: 0;
  }
</style>
```

## Focus Trap Utility

```typescript
// utils/focus-trap.ts
export function createFocusTrap(container: HTMLElement) {
  const focusableSelectors = [
    'button:not([disabled])',
    '[href]',
    'input:not([disabled])',
    'select:not([disabled])',
    'textarea:not([disabled])',
    '[tabindex]:not([tabindex="-1"])'
  ].join(', ');

  let previouslyFocused: HTMLElement | null = null;

  function getFocusableElements(): HTMLElement[] {
    return Array.from(container.querySelectorAll(focusableSelectors));
  }

  function handleKeydown(e: KeyboardEvent) {
    if (e.key !== 'Tab') return;

    const focusable = getFocusableElements();
    if (focusable.length === 0) return;

    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  }

  return {
    activate() {
      previouslyFocused = document.activeElement as HTMLElement;
      container.addEventListener('keydown', handleKeydown);
      const focusable = getFocusableElements();
      focusable[0]?.focus();
    },
    deactivate() {
      container.removeEventListener('keydown', handleKeydown);
      previouslyFocused?.focus();
    }
  };
}
```

## Screen Reader Only Utility Class

```css
/* Include in global styles */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

## Interactive Component Pattern

Complete example of accessible tier selection with radiogroup pattern:

```html
<!-- Radiogroup pattern for selection -->
<div class="options" role="radiogroup" aria-label="Select your option">
    <button type="button" class="option-btn" role="radio"
            aria-checked="true" data-value="option1">Option 1</button>
    <button type="button" class="option-btn" role="radio"
            aria-checked="false" data-value="option2">Option 2</button>
    <button type="button" class="option-btn" role="radio"
            aria-checked="false" data-value="option3">Option 3</button>
</div>

<!-- Live region for state change announcements -->
<div role="status" aria-live="polite" aria-atomic="true" class="sr-only"
     id="selection-status"></div>
```

```javascript
// Handle selection
function selectOption(button) {
    const value = button.dataset.value;

    // Update ARIA states
    document.querySelectorAll('.option-btn').forEach(btn => {
        btn.setAttribute('aria-checked', 'false');
    });
    button.setAttribute('aria-checked', 'true');

    // Announce to screen readers
    const statusDiv = document.getElementById('selection-status');
    statusDiv.textContent = `${value} selected`;
}

// Keyboard navigation
document.querySelector('.options').addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
        e.preventDefault();
        focusNextRadio();
    } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
        e.preventDefault();
        focusPreviousRadio();
    } else if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        e.target.click();
    }
});
```

```css
/* Focus state (keyboard navigation) */
.option-btn:focus-visible {
    outline: 2px solid var(--focus-color);
    outline-offset: 2px;
}

/* Selected state */
.option-btn[aria-checked="true"] {
    border: 2px solid var(--accent-color);
    background: var(--accent-bg);
}
```

### Key Implementation Notes

1. **ARIA markup**: `role="radiogroup"`, `role="radio"`, `aria-checked` for proper semantics
2. **Live region**: `aria-live="polite"` announces state changes without interrupting
3. **Keyboard support**: Arrow keys navigate, Enter/Space activates
4. **Distinct visual states**: Selected uses border/background change
5. **Focus management**: `focus-visible` shows keyboard focus, logical tab order
