---
title: Clean Up Side Effects Registered in Watchers
impact: MEDIUM-HIGH
impactDescription: Prevents memory leaks from accumulated callbacks, timers, and listeners
tags: vue, watch, watchEffect, cleanup, onCleanup, onWatcherCleanup
---

## Clean Up Side Effects Registered in Watchers

**Impact: MEDIUM-HIGH — watchers that register listeners/timers without cleanup cause leaks**

When a `watch`/`watchEffect` callback registers side effects (event listeners, timers, SSE subscriptions), the previous effect must be cleaned up before the new one runs.

**Violation pattern:** `watch(...)` callback that calls `.on()`, `addEventListener`, `setInterval`, or creates resources, without an `onCleanup`/`onWatcherCleanup` callback.

**Fix pattern (Vue 3.5+):**
```ts
watch(selectedId, (newId) => {
  const timer = setInterval(() => fetch(newId), 1000)
  onWatcherCleanup(() => clearInterval(timer))
})
```

**Fix pattern (Vue 3.4 and below):**
```ts
watch(selectedId, (newId, oldId, onCleanup) => {
  const timer = setInterval(() => fetch(newId), 1000)
  onCleanup(() => clearInterval(timer))
})
```

**Detection:**
```
rg "watch\(|watchEffect\(" src/ -g "*.vue" -g "*.ts"
rg "onCleanup|onWatcherCleanup" src/ -g "*.vue" -g "*.ts"
```
The ratio should be roughly 1:1 for watches that register side effects.

**Auto-fix:** For each `watch` that registers side effects, add `onCleanup` (or `onWatcherCleanup` for Vue 3.5+) that reverses the effect.
