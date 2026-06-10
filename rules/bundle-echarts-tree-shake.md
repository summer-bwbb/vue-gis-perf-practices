---
title: Import ECharts Components on Demand
impact: CRITICAL
impactDescription: Reduces ECharts bundle from ~1MB to ~200KB
tags: bundle, echarts, tree-shake, import, on-demand
---

## Import ECharts Components on Demand

**Impact: CRITICAL — full ECharts import adds ~1MB to the bundle**

ECharts 5+ supports tree-shaking. Importing everything pulls in every chart type, renderer, and component. Register only what's actually used.

**Violation pattern:** `import * as echarts from 'echarts'`

**Fix pattern:**
```ts
import * as echarts from 'echarts/core'
import { BarChart, LineChart } from 'echarts/charts'
import { GridComponent, TooltipComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
echarts.use([BarChart, LineChart, GridComponent, TooltipComponent, LegendComponent, CanvasRenderer])
```
Scan the file's `setOption(...)` calls to determine which chart types and components are used, then register only those.

**Detection:**
```
rg "from ['\"]echarts['\"]|import \* as echarts from ['\"]echarts['\"]" src/ -g "*.ts" -g "*.vue"
```
Violation if this matches. Cross-check with `rg "echarts/core" src/ -g "*.ts" -g "*.vue"`.

**Auto-fix:** Replace full echarts import with `echarts/core` + selective chart/component imports. Add `echarts.use([...])` with only the components referenced in `setOption`.
