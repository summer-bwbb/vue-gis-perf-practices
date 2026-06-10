---
title: Balance addEventListener with removeEventListener
impact: MEDIUM
impactDescription: Prevents CPU waste and memory leaks from orphaned DOM event listeners
tags: render, event, listener, cleanup, addEventListener, removeEventListener, DOM
---

## Balance addEventListener with removeEventListener

**Impact: MEDIUM — orphaned listeners fire against stale component state**

Every `addEventListener` on a DOM element, `window`, or `document` must have a matching `removeEventListener` with the **same function reference** in `onBeforeUnmount`.

**Violation pattern:** `addEventListener` without matching `removeEventListener` in the same component, or anonymous function passed to `addEventListener` (cannot be referenced for removal).

**Fix pattern:**
```ts
const handleKeydown = (e: KeyboardEvent) => { /* ... */ }
// In onMounted: document.addEventListener('keydown', handleKeydown)
// In onBeforeUnmount: document.removeEventListener('keydown', handleKeydown)
```

**Why:** Anonymous functions can't be removed. `window`/`document` listeners survive route changes. GIS projects often add keyboard shortcuts and resize handlers — all need cleanup.

**Detection:**
```
rg -c "addEventListener" src/ -g "*.vue" -g "*.ts"
rg -c "removeEventListener" src/ -g "*.vue" -g "*.ts"
```
Per-file violation if add count exceeds remove count.

**Auto-fix:** Extract anonymous callbacks to named functions. Add `removeEventListener` in `onBeforeUnmount`. Prefer VueUse's `useEventListener` for automatic cleanup.
