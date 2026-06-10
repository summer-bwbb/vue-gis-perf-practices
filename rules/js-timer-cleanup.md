---
title: Clear All Timers in onBeforeUnmount
impact: MEDIUM
impactDescription: Prevents phantom timers that consume CPU and cause stale state updates
tags: js, timer, setInterval, setTimeout, clearInterval, clearTimeout, cleanup, unmount
---

## Clear All Timers in onBeforeUnmount

**Impact: MEDIUM — orphaned timers fire callbacks on unmounted components**

`setInterval` and `setTimeout` return handles that must be cleared with `clearInterval`/`clearTimeout`. Orphaned timers continue firing, updating stale refs or triggering side effects on destroyed state.

**Violation pattern:** `setInterval`/`setTimeout` in a Vue component without matching `clearInterval`/`clearTimeout` in `onBeforeUnmount`.

**Fix pattern:**
```ts
const timer = setInterval(() => { ... }, 1000)
onBeforeUnmount(() => clearInterval(timer))
```

**Why:** Timers survive component unmount. Their callbacks access stale component state, causing errors or ghost updates.

**Detection:**
```
rg -c "setInterval|setTimeout" src/ -g "*.vue" -g "*.ts"
rg -c "clearInterval|clearTimeout" src/ -g "*.vue" -g "*.ts"
```
Per-file violation if set* count exceeds clear* count.

**Auto-fix:** Extract anonymous timer callbacks to named functions. Store timer handle and clear it in `onBeforeUnmount`.
