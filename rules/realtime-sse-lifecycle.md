---
title: Manage SSE Connection Lifecycle per Component
impact: HIGH
impactDescription: Prevents ghost connections that consume server resources and browser memory
tags: sse, lifecycle, connection, cleanup, unmount, EventSource
---

## Manage SSE Connection Lifecycle per Component

**Impact: HIGH — orphaned SSE connections persist until browser tab closes**

SSE connections are long-lived HTTP streams. Orphaned connections consume a browser socket slot and server resources.

**Two patterns:**

**Per-component SSE — violation:** `new EventSource(...)` without `.close()` in `onBeforeUnmount`.
Fix: store in `shallowRef`, call `.close()` on unmount.

**Global singleton SSE + mitt — violation:** `emitter.on(...)` without matching `emitter.off(...)` in `onBeforeUnmount`.
Fix: always pair `emitter.on(eventName, handler)` with `emitter.off(eventName, handler)` on unmount.

**Why:** Browser limits ~6 concurrent HTTP/1.1 connections per domain. Ghost SSE connections eat into this limit. For singleton SSE via mitt, per-component listeners must be cleaned up to prevent stale callbacks.

**Detection:**
```
rg "new EventSource|EventSource\(" src/ -g "*.vue" -g "*.ts"
rg "\.close\(\)" src/ -g "*.vue" -g "*.ts"
rg "emitter\.on\(" src/ -g "*.vue" -g "*.ts"
rg "emitter\.off\(" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix:** For per-component SSE, store in `shallowRef` and call `.close()` in `onBeforeUnmount`. For singleton + mitt, pair every `emitter.on()` with `emitter.off()` in the same component's cleanup.
