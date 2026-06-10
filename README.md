# vue-gis-perf-practices

[![Agent Skill](https://img.shields.io/badge/Agent-Skill-6366f1)](SKILL.md)
[![Vue 3](https://img.shields.io/badge/Vue-3-42b883?logo=vue.js&logoColor=white)](https://vuejs.org/)
[![GIS](https://img.shields.io/badge/GIS-3D%20%26%20Mapping-2ea043)](https://en.wikipedia.org/wiki/Geographic_information_system)
[![Cesium](https://img.shields.io/badge/Cesium-JS-6CADFF?logo=cesium&logoColor=white)](https://cesium.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Languages / 语言 / 語言**

**English** · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md)

---

### Overview

**vue-gis-perf-practices** is an **Agent Skill** for **Vue 3 + GIS** projects. It follows the standard Agent Skills format (`SKILL.md` entry point, progressive rule loading) and can be used with any AI coding agent that supports skills. It provides structured performance rules, code review workflows, and full-project diagnostic reports for stacks that use **Cesium**, **OpenLayers**, **Three.js**, **ECharts**, **SSE/WebSocket**, and other heavy 3D/GIS libraries.

The skill follows a **search-first, progressive disclosure** approach: it never bulk-loads all rules. Instead, it detects patterns in your codebase and loads only the rules that apply.

### When to Use

| Trigger | Mode |
|---------|------|
| "Review code", "check performance", PR review | **Mode A** — Rule Review |
| "Performance diagnostic", "generate report", full scan | **Mode B** — Project Diagnostic Report |

Reports and chat output support **English**, **Simplified Chinese (zh)**, and **Traditional Chinese (zh-TW)**.

### Rule Categories (18 rules, 9 categories)

| Category | Prefix | Severity | Focus |
|----------|--------|----------|-------|
| GIS Memory & Entity Management | `cesium-*` | CRITICAL | `shallowRef`, Viewer lifecycle, event handler cleanup |
| Bundle Size Optimization | `bundle-*` | CRITICAL | Manual chunks, ECharts tree-shaking, Element Plus on-demand |
| Realtime Connection Management | `realtime-*` | HIGH | SSE lifecycle, reconnect backoff, graceful fallback |
| Vue Reactivity Optimization | `vue-*` | MEDIUM-HIGH | Large-object `shallowRef`, component split, watch cleanup |
| API & Data Flow | `api-*` | MEDIUM-HIGH | Cancel requests on unmount (`AbortController`) |
| Rendering Performance | `render-*` | MEDIUM | DOM event listener cleanup |
| Map Interactions | `map-*` | MEDIUM | Map event throttle / debounce |
| JavaScript General | `js-*` | LOW-MEDIUM | Timer cleanup (`setInterval` / `setTimeout`) |
| Build & Deploy | `build-*` | LOW | Vite build config (sourcemap, chunk limits) |

### Work Modes

#### Mode A — Rule Review (per-file / per-PR)

1. Detect output language from user message
2. Read target file(s) and identify imports / patterns
3. Load `rules/_sections.md` and match detection patterns
4. Load **only** matched rule files and confirm violations
5. Report: rule ID, severity, file:line, problem code, fix code

#### Mode B — Project Diagnostic Report

1. **Scan** — Run file-size scan (`scripts/scan-project.ps1` or equivalent)
2. **Metrics** — Collect counts via `rg` (e.g. `shallowRef`, Cesium imports, listeners, timers, unmount hooks)
3. **Rule matching** — Two-pass: detection scan → confirm violations (no bulk rule loading)
4. **Report** — Fill language template and save as `{project-name} {YYYY-MM-DD} {HH-mm-ss}.md`

Report dimensions include: GIS memory, bundle size, realtime connections, Vue reactivity, event lifecycle, component size, API flow, and build configuration.

### Installation

1. Clone this repository:

```bash
git clone https://github.com/summer-bwbb/vue-gis-perf-practices.git
```

2. Copy the entire `vue-gis-perf-practices` folder into your agent's skills directory. Refer to your agent's documentation for the correct path.

```bash
cp -r vue-gis-perf-practices /path/to/your/agent/skills/
```

3. Invoke the skill by name or through performance-related requests—the agent loads `SKILL.md` and applies the matching rules automatically.

### Usage Examples

```
Use vue-gis-perf-practices to review src/components/MapViewer.vue for performance issues.
```

```
Run a full performance diagnostic on this project and generate a report in English.
```

```
用 vue-gis-perf-practices 对项目进行性能诊断，生成中文报告。
```

```
使用 vue-gis-perf-practices 進行效能診斷，產出繁體中文報告。
```

### Project Structure

```
vue-gis-perf-practices/
├── SKILL.md                 # Skill entry point & workflow
├── metadata.json            # Version & references
├── rules/
│   ├── _sections.md         # Rule index & detection patterns (load first)
│   ├── _template.md         # Rule file format
│   ├── cesium-*.md          # GIS memory rules
│   ├── bundle-*.md          # Bundle optimization rules
│   ├── realtime-*.md        # SSE / WebSocket rules
│   ├── vue-*.md             # Vue reactivity rules
│   └── ...                  # api, render, map, js, build
├── references/
│   ├── report-template-en.md
│   ├── report-template-zh.md
│   ├── report-template-zh-TW.md
│   └── i18n.md              # Multilingual term mapping
├── scripts/
│   └── scan-project.ps1     # Project file-size scanner
└── agents/
    └── openai.yaml          # Agent interface config
```

### References

- [Vue Performance Best Practices](https://vuejs.org/guide/best-practices/performance.html)
- [CesiumJS Coding Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md)
- [Vite Performance Guide](https://vitejs.dev/guide/performance)
- [Vue Reactivity In Depth](https://vuejs.org/guide/extras/reactivity-in-depth.html#how-reactivity-works-in-vue)

### License

[MIT](LICENSE) © 2026 summer-bwbb
