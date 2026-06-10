---
title: Use Exponential Backoff for SSE Reconnection
impact: HIGH
impactDescription: Prevents reconnection storm that can overwhelm the server
tags: sse, reconnect, backoff, retry, exponential
---

## Use Exponential Backoff for SSE Reconnection

**Impact: HIGH — fixed-interval retry creates a reconnection storm during outages**

Retrying with a fixed short interval (e.g., 1 second) generates a flood of requests during an extended server outage, amplifying the problem.

**Violation pattern:** `retryDelay: 1000` (fixed) with high `maxRetryCount` without exponential backoff logic.

**Fix pattern:**
```ts
const getRetryDelay = (retryCount: number) => Math.min(1000 * Math.pow(2, retryCount), 30000)
// 1s, 2s, 4s, 8s, 16s, 30s, 30s, ...
// maxRetryCount: 10 (covers ~17 min with backoff)
```

**Why:** Exponential backoff spreads retry load over time, giving the server breathing room. Cap at 30s to ensure eventual reconnection. If user navigates back, `forceReconnect()` resets the counter.

**Detection:**
```
rg "retryDelay|maxRetryCount" src/ -g "*.vue" -g "*.ts"
rg "Math\.pow|exponential|backoff" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix:** Add a `getRetryDelay(count)` function using exponential backoff. Reduce `maxRetryCount` from 50 to 10-15. Modify `scheduleReconnect` to use it.
