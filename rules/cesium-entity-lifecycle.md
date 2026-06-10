---
title: Destroy Cesium Entities and Layers on Component Unmount
impact: CRITICAL
impactDescription: Prevents memory leaks that accumulate with each page navigation
tags: cesium, entity, lifecycle, memory-leak, destroy, unmount
---

## Destroy Cesium Entities and Layers on Component Unmount

**Impact: CRITICAL — prevents unbounded memory growth during navigation**

Cesium entities, primitives, tilesets, and data sources are not garbage-collected automatically when a Vue component unmounts. Each navigation cycle leaks memory.

**Violation pattern:** `new Viewer(...)` or `Viewer(...)` in a Vue component without matching `.destroy()` call in `onBeforeUnmount`/`onUnmounted`.

**Fix pattern:**
```ts
// In onBeforeUnmount:
viewer.value.entities.removeAll()
viewer.value.scene.primitives.removeAll()
viewer.value.destroy()
viewer.value = null
```

**Why:** Cesium does not integrate with Vue's reactivity or component lifecycle. Objects persist until explicitly destroyed. `viewer.destroy()` releases WebGL contexts, GPU memory, and internal event listeners.

**Detection:**
```
rg "new Viewer|Viewer\(" src/ -g "*.vue" -g "*.ts"
rg "\.destroy\(\)" src/ -g "*.vue" -g "*.ts"
```
Violation if Viewer creation count exceeds destroy count.

**Auto-fix:** For every `new Viewer(...)` in a Vue component, add cleanup in `onBeforeUnmount`. If the viewer is in a composable, ensure it returns a cleanup function.
