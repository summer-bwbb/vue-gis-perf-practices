# Rule Sections & Detection Index

Load this file first in any review or diagnostic. Run detection patterns against the project, then load only matched rules.

## 1. cesium-* — GIS Memory & Entity Management (CRITICAL)

**Category detection:** Cesium usage exists if any `.vue`/`.ts` file imports from `cesium`.
```
rg -l "from ['\"]cesium|Cesium\.Viewer|new Cesium" src/ -g "*.vue" -g "*.ts"
```
If zero matches, skip this entire category.

| Rule | File | Detection (run against project) |
|------|------|--------------------------------|
| shallowRef for Cesium/Three.js | `cesium-shallow-ref.md` | `rg "ref<\s*Viewer|ref\(.*new.*(Viewer\|Scene\|Camera\|WebGLRenderer)" src/ -g "*.vue" -g "*.ts"` |
| Entity/layer lifecycle | `cesium-entity-lifecycle.md` | `rg "new Viewer" src/ -g "*.vue" -g "*.ts"` then cross-check `rg "\.destroy\(\)" src/ -g "*.vue" -g "*.ts"` |
| Event handler cleanup | `cesium-event-cleanup.md` | `rg "ScreenSpaceEventHandler\|new.*Handler" src/ -g "*.vue" -g "*.ts"` |

## 2. bundle-* — Bundle Size Optimization (CRITICAL)

**Category detection:** Always check; Vite config exists in every project.
```
rg "manualChunks\|echarts\|element-plus" vite.config.ts
```

| Rule | File | Detection |
|------|------|-----------|
| Manual chunk splitting | `bundle-manual-chunks.md` | `rg "manualChunks" vite.config.ts` — check if `cesium\|three\|echarts\|ol` are in their own chunks |
| ECharts on-demand | `bundle-echarts-tree-shake.md` | `rg "from ['\"]echarts['\"]\|\* as echarts" src/ -g "*.ts" -g "*.vue"` |
| Element Plus on-demand | `bundle-element-plus-on-demand.md` | `rg "import ElementPlus\|app\.use\(ElementPlus\)" src/ -g "*.ts"` |

## 3. realtime-* — Realtime Connection Management (HIGH)

**Category detection:** SSE/WebSocket usage.
```
rg -l "new EventSource\|SSE\|EventSource\(" src/ -g "*.vue" -g "*.ts"
```
If zero matches, skip this entire category.

| Rule | File | Detection |
|------|------|-----------|
| SSE connection lifecycle | `realtime-sse-lifecycle.md` | `rg "new EventSource\|EventSource\(" src/ -g "*.vue" -g "*.ts"` then cross-check `rg "\.close\(\)" src/ -g "*.vue" -g "*.ts"` |
| Reconnect backoff | `realtime-sse-reconnect-backoff.md` | `rg "retryDelay\|maxRetryCount" src/ -g "*.vue" -g "*.ts"` |
| Graceful fallback | `realtime-sse-graceful-fallback.md` | `rg "localStorage\.clear\(\)\|location\.reload\(\)" src/ -g "*.vue" -g "*.ts"` near SSE code |

## 4. vue-* — Vue Reactivity Optimization (MEDIUM-HIGH)

**Category detection:** Always check; every Vue project has these patterns.

| Rule | File | Detection |
|------|------|-----------|
| shallowRef for large objects | `vue-shallow-ref-large.md` | `rg "= ref\(.*\b(Map\|Chart\|Viewer\|Scene\|Renderer\|init\|new )" src/ -g "*.vue" -g "*.ts"` |
| Split oversized components | `vue-component-split.md` | PowerShell: `Get-ChildItem -Path "src" -Recurse -Include "*.vue" -File \| Where-Object { $_.Length -gt 30000 }` |
| Watch cleanup | `vue-watch-cleanup.md` | `rg "watch\(\|watchEffect\(" src/ -g "*.vue" -g "*.ts"` then cross-check `rg "onCleanup\|onWatcherCleanup" src/ -g "*.vue" -g "*.ts"` |

## 5. api-* — API & Data Flow (MEDIUM-HIGH)

**Category detection:** Axios/fetch usage.
```
rg -l "axios\.(get\|post\|put\|delete\|patch)\(" src/ -g "*.vue" -g "*.ts"
```
If zero matches and no fetch calls, skip.

| Rule | File | Detection |
|------|------|-----------|
| Cancel on unmount | `api-cancel-on-unmount.md` | `rg "axios\.(get\|post\|put\|delete\|patch)\(" src/ -g "*.vue" -g "*.ts"` then cross-check `rg "AbortController\|signal:" src/ -g "*.vue" -g "*.ts"` |

## 6. render-* — Rendering Performance (MEDIUM)

**Category detection:** DOM event listeners.
```
rg -c "addEventListener" src/ -g "*.vue" -g "*.ts"
```

| Rule | File | Detection |
|------|------|-----------|
| Event listener cleanup | `render-event-cleanup.md` | Compare `rg -c "addEventListener"` count vs `rg -c "removeEventListener"` per file |

## 7. map-* — Map Interactions (MEDIUM)

**Category detection:** Map event listeners (OpenLayers `.on()` / Cesium events).
```
rg "map\.on\(|\.on\('moveend\|\.on\('click\|\.on\('pointermove" src/ -g "*.vue" -g "*.ts"
```

| Rule | File | Detection |
|------|------|-----------|
| Map event throttle | `map-event-throttle.md` | `rg "map\.on\(|\.on\('moveend\|\.on\('pointermove" src/ -g "*.vue" -g "*.ts"` then cross-check for throttle/debounce |

## 8. js-* — JavaScript General (LOW-MEDIUM)

**Category detection:** Timer usage.
```
rg -c "setInterval\|setTimeout" src/ -g "*.vue" -g "*.ts"
```

| Rule | File | Detection |
|------|------|-----------|
| Timer cleanup | `js-timer-cleanup.md` | `rg "setInterval\|setTimeout" src/ -g "*.vue" -g "*.ts"` then cross-check per-file `rg "clearInterval\|clearTimeout"` |

## 9. build-* — Build & Deploy (LOW)

**Category detection:** Always check vite config.
```
rg "sourcemap\|chunkSizeWarningLimit\|reportCompressedSize\|esbuild" vite.config.ts
```

| Rule | File | Detection |
|------|------|-----------|
| Vite build config | `build-vite-config.md` | `rg "sourcemap\|chunkSizeWarningLimit\|reportCompressedSize\|esbuild" vite.config.ts` |

---

## Usage in Mode B (Diagnostic)

1. Run the category-level detection first. Skip any category with zero matches.
2. For remaining categories, run each rule's detection pattern.
3. Load only rules whose patterns returned matches.
4. Apply loaded rules to confirm violations and collect file:line data.

DO NOT load rule files whose detection patterns returned zero matches.
