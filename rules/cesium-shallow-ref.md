---
title: Use shallowRef for Cesium/Three.js Viewer Instances
impact: CRITICAL
impactDescription: 30-50% reduction in Cesium-related memory usage, eliminates deep Proxy overhead
tags: cesium, threejs, reactivity, shallowRef, memory, viewer
---

## Use shallowRef for Cesium/Three.js Viewer Instances

**Impact: CRITICAL — eliminates deep Proxy overhead on complex 3D objects**

Vue 3's `ref()` wraps values in a deep reactive Proxy. Cesium Viewer, EntityCollection, and Three.js Scene/Renderer contain thousands of nested properties. Deep-proxying causes massive memory overhead, 2-5x slower property access, and subtle bugs.

**Violation pattern:** `ref<Viewer>` or `ref(new Viewer(...))` or `ref(new Scene(...))` in `.vue`/`.ts` files.

**Fix pattern:**
```ts
const viewer = shallowRef<Viewer | null>(null)  // GOOD: no deep Proxy
```

**Why:** `shallowRef` only tracks `.value` reassignment — exactly right for 3D engine instances that manage their own internal state.

**Detection:**
```
rg "ref<\s*Viewer|ref\(.*new.*(Viewer|Scene|Camera|WebGLRenderer)" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix:** Replace `ref(` with `shallowRef(` for any variable holding Cesium Viewer, EntityCollection, PrimitiveCollection, Three.js Scene, Camera, or WebGLRenderer. Add `import { shallowRef } from 'vue'` if needed.
