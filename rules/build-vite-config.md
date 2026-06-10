---
title: Optimize Vite Build Config for GIS Projects
impact: LOW
impactDescription: Reduces build output size and improves long-term cache hit rate
tags: build, vite, config, sourcemap, chunk, compress, cdn, optimization
---

## Optimize Vite Build Config for GIS Projects

**Impact: LOW — incremental build improvements for production deployment**

GIS projects have unique build challenges: Cesium assets are huge, Three.js and ECharts are large libraries.

**Key settings to check:**
- `sourcemap: false` — Cesium sourcemaps are enormous
- `chunkSizeWarningLimit: 2048` — Cesium + Three chunks exceed default 500KB
- `reportCompressedSize: false` — saves 10-30s build time
- `esbuild.pure: ['console.log']` — strip debug logs
- `esbuild.drop: ['debugger']` — remove debugger statements
- `esbuild.legalComments: 'none'` — strip comments
- `manualChunks` — split cesium, three, echarts, ol into separate chunks

**Detection:**
```
rg "sourcemap|chunkSizeWarningLimit|reportCompressedSize|manualChunks|esbuild" vite.config.ts
```

**Auto-fix:** Apply recommended settings to `vite.config.ts`. Do not change `proxy` or `server` settings. Match `manualChunks` entries to project's actual dependencies.
