---
title: Split Heavy Libraries into Separate Chunks
impact: CRITICAL
impactDescription: Reduces initial load by 2-5MB; enables parallel loading and long-term caching
tags: bundle, vite, manualChunks, cesium, three, echarts, openlayers
---

## Split Heavy Libraries into Separate Chunks

**Impact: CRITICAL — single vendor chunk with Cesium + Three + ECharts + OL can exceed 10MB**

Vite's default chunking puts all shared dependencies into a single vendor chunk. For GIS projects, split heavy libraries into separate, cacheable chunks.

**Violation pattern:** `manualChunks` does not include separate entries for `cesium`, `three`, `echarts`, `ol`.

**Fix pattern:**
```ts
manualChunks: {
  vue: ['vue', 'vue-router', 'axios', 'pinia'],
  element: ['element-plus', '@element-plus/icons-vue'],
  cesium: ['cesium'],
  three: ['three'],
  echarts: ['echarts'],
  ol: ['ol']
}
```

**Why:** Separate chunks enable parallel downloading. Cesium rarely changes — a separate chunk gets long-term cache hits. Smaller chunks mean faster incremental updates.

**Detection:**
```
rg "manualChunks" vite.config.ts
rg "cesium|three|echarts|ol" vite.config.ts
```

**Auto-fix:** Add `manualChunks` entries for each heavy library in `package.json`. Each entry: `libraryName: ['package-name']`.
