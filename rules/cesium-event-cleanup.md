---
title: Destroy Cesium Event Handlers on Unmount
impact: CRITICAL
impactDescription: Prevents CPU spin from orphaned event handlers and memory leaks
tags: cesium, event, handler, cleanup, ScreenSpaceEventHandler, destroy
---

## Destroy Cesium Event Handlers on Unmount

**Impact: CRITICAL — orphaned handlers consume CPU on every mouse/frame event**

Cesium's `ScreenSpaceEventHandler`, `Event.addEventListener`, and `Clock.onTick` register callbacks that persist until explicitly removed. If not cleaned up on unmount, they fire continuously against stale component state.

**Violation pattern:** `ScreenSpaceEventHandler` or `new.*Handler` in a Vue component without matching `.destroy()`.

**Fix pattern:**
```ts
let handler: ScreenSpaceEventHandler | null = null
// In onMounted: handler = new ScreenSpaceEventHandler(viewer.scene.canvas)
// In onBeforeUnmount: handler?.destroy(); handler = null
```

**Also applies to:**
- `viewer.clock.onTick.addEventListener(...)` → matching `removeEventListener`
- `viewer.scene.postRender.addEventListener(...)` → matching remove

**Detection:**
```
rg "ScreenSpaceEventHandler|new.*Handler" src/ -g "*.vue" -g "*.ts"
rg "\.destroy\(\)|removeEventListener" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix:** Store every `ScreenSpaceEventHandler` in a variable. In `onBeforeUnmount`, call `.destroy()`. For `.addEventListener` on Cesium events, register a matching `.removeEventListener`.
