---
title: Cancel Pending API Requests on Component Unmount
impact: MEDIUM-HIGH
impactDescription: Prevents stale data from overwriting fresh state after navigation
tags: api, axios, cancel, abort, unmount, request
---

## Cancel Pending API Requests on Component Unmount

**Impact: MEDIUM-HIGH — stale responses arriving after navigation corrupt component state**

When a user navigates away before an API response arrives, the response handler may try to update state on an unmounted component. This causes Vue warnings, and if the component remounts, stale data overwrites fresh data.

**Violation pattern:** `axios.get/post/put/delete/patch(...)` without `AbortController` and `signal:` option, and no `controller.abort()` in `onBeforeUnmount`.

**Fix pattern (AbortController):**
```ts
let controller: AbortController | null = null
// In onMounted: controller = new AbortController(); axios.get(url, { signal: controller.signal })
// In onBeforeUnmount: controller?.abort()
```

**Why:** `AbortController` is the standard browser API for cancelling fetch/axios requests. For pages with rapid navigation (e.g., switching between drone details), cancellation prevents stale data flash.

**Detection:**
```
rg "axios\.(get|post|put|delete|patch)\(" src/ -g "*.vue" -g "*.ts"
rg "AbortController|signal:" src/ -g "*.vue" -g "*.ts"
```
If axios calls exist but AbortController count is 0, rule is violated.

**Auto-fix:** Create an `AbortController` before the request, pass `{ signal: controller.signal }` to axios, call `controller.abort()` in `onBeforeUnmount`.
