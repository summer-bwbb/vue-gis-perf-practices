---
title: Handle SSE Init Failure Without Clearing All State
impact: HIGH
impactDescription: Prevents data loss from destructive localStorage.clear() during transient SSE failures
tags: sse, graceful, fallback, localStorage, init-failure, error-handling
---

## Handle SSE Init Failure Without Clearing All State

**Impact: HIGH — prevents data loss from destructive `localStorage.clear()` during transient SSE failures**

Some SSE implementations call `localStorage.clear()` or `location.reload()` on connection failure. This is destructive: it wipes auth tokens, user preferences, and cached data for a transient network issue.

**Violation pattern:** `localStorage.clear()` or `location.reload()` in SSE error/init-failure handlers.

**Fix pattern:**
```ts
catch (err) {
  console.warn('[SSE] init failed, will retry on next realtime page visit', err)
  emitter.emit(SSE_EVENT_STATUS, { status: 'INIT_ERROR', retryCount: 0 })
  // Do NOT clear localStorage or reload. Let UI show a "connection lost" banner.
}
```

**Why:** SSE failure is typically network/server, not auth. `localStorage.clear()` is only appropriate for genuine auth expiration (401/421). `location.reload()` hides root cause and creates poor UX loops.

**Detection:**
```
rg "localStorage\.clear\(\)" src/ -g "*.vue" -g "*.ts"
rg "location\.reload\(\)" src/ -g "*.vue" -g "*.ts"
```
Cross-reference with SSE files: `rg "sse|SSE|EventSource" src/ -g "*.vue" -g "*.ts"`

**Auto-fix:** Remove `localStorage.clear()` and `location.reload()` from SSE error handlers. Replace with status emitter. Let UI handle error display.
