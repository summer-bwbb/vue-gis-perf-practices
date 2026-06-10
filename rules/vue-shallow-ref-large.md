---
title: Use shallowRef for Large Non-Reactive Objects
impact: MEDIUM-HIGH
impactDescription: Eliminates deep Proxy overhead on objects with hundreds of properties
tags: vue, shallowRef, reactivity, performance, large-object
---

## Use shallowRef for Large Non-Reactive Objects

**Impact: MEDIUM-HIGH — deep Proxy on complex objects causes memory and CPU overhead**

`ref()` wraps values in a deep reactive Proxy. For objects with many nested properties (map/chart instances, large API response caches), the Proxy intercepts every property access needlessly.

**When to use shallowRef:** Cesium/Three.js/OL instances, ECharts instances, DOM refs, large API response lists (1000+ items).

**Violation pattern:** `ref(new Map(...))`, `ref(chart.init(...))`, or `ref(largeDataset)` where deep reactivity isn't needed.

**Fix pattern:**
```ts
const olMap = shallowRef(new Map({ target: 'map' }))
const tableData = shallowRef(await fetchHugeDataset())
// Use triggerRef(tableData) if mutating in-place and need template update
```

**Detection:**
```
rg "= ref\(.*\b(Map|Chart|Viewer|Scene|Renderer|init|new )" src/ -g "*.vue" -g "*.ts"
rg -c "shallowRef" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix:** Replace `ref(` with `shallowRef(` when value is an engine instance, DOM ref, or large data array where deep reactivity is not needed. Add `triggerRef()` calls if code mutates `.value` properties in-place.
