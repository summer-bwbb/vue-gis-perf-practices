---
title: Throttle High-Frequency Map Events
impact: MEDIUM
impactDescription: Reduces CPU usage from tens of thousands to dozens of callbacks per interaction
tags: map, event, throttle, debounce, moveend, pointermove, cesium, openlayers
---

## Throttle High-Frequency Map Events

**Impact: MEDIUM — high-frequency events fire thousands of times during a single interaction**

Map events like `moveend`, `pointermove`, zoom, and camera changes fire at 60+ FPS. Without throttling, each event triggers expensive state updates, API calls, or DOM mutations.

**Violation pattern:** `map.on('moveend', callback)` or `viewer.camera.changed.addEventListener(callback)` without `throttle`/`debounce` wrapper.

**Fix pattern:**
```ts
import { throttle } from 'lodash-es' // or useDebounceFn from @vueuse/core
map.on('moveend', throttle(() => { updateOverlays() }, 100))
viewer.camera.changed.addEventListener(throttle(() => { syncCamera() }, 100))
```

**Why:** Lodash `throttle` (or `useThrottleFn` from VueUse) reduces callbacks from 60/sec to ~10/sec. `debounce` is better for events that should fire after interaction stops (e.g., auto-save).

**Detection:**
```
rg "map\.on\(|\.on\('moveend|\.on\('pointermove|camera\.changed" src/ -g "*.vue" -g "*.ts"
rg "throttle|debounce" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix:** Wrap high-frequency map event callbacks with `throttle(fn, 100)` or `debounce(fn, 300)`. Prefer `lodash-es` for tree-shaking or `@vueuse/core` utilities.
