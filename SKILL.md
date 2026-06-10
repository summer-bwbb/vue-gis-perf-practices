---
name: vue-gis-perf-practices
description: Vue 3 + GIS (Cesium/OpenLayers/Three.js) performance optimization, code analysis, and diagnostics. Use when reviewing, refactoring, or diagnosing Vue 3 projects that use Cesium, OpenLayers, Three.js, ECharts, SSE, or heavy 3D/GIS stacks. Triggers on performance review, code analysis, memory leak diagnosis, bundle optimization, SSE/WebSocket lifecycle audit, rendering performance, or generating a full project performance report.
---

# Vue GIS Performance Practices

Performance optimization rules and diagnostic workflow for Vue 3 + GIS applications. Reports support zh (Simplified Chinese), zh-TW (Traditional Chinese), and en (English).

**CRITICAL — Progressive disclosure:** Never bulk-load all rule files. Always search first, then load only the specific rules whose detection patterns match. See `rules/_sections.md` for the index with detection patterns.

## Language Selection

Detect language from user request. Fallback to project UI language.

| User input | Lang | Template |
|------------|------|----------|
| Chinese / Simplified | `zh` | `references/report-template-zh.md` |
| Traditional Chinese | `zh-TW` | `references/report-template-zh-TW.md` |
| English | `en` | `references/report-template-en.md` |

Only load the matching template during Step 4 (report generation). Do not load i18n.md or templates before Step 4.

## Rule Categories

See `rules/_sections.md` for the full category index with detection patterns and file names. Load it as the first step in any review or diagnostic.

Summary: 9 categories across `cesium-*`, `bundle-*`, `realtime-*`, `vue-*`, `api-*`, `render-*`, `map-*`, `js-*`, `build-*` prefixes. 18 rules total.

## Work Modes

### Mode A: Rule Review (per-file / per-PR)

Trigger: "review code", "check performance", or similar.

1. Determine output language from user message
2. Read the target file(s) to identify imports and patterns
3. **Search-first:** Load `rules/_sections.md` (not all rules). Match detected imports to rule prefixes:
   - Cesium imports → `cesium-*` rules
   - SSE/WebSocket → `realtime-*` rules
   - Vue component → `vue-*` rules
   - Vite config → `build-*` rules
4. **Load only matched rules.** For each loaded rule, run its detection pattern against the target file to confirm
5. Report each confirmed violation with: rule ID, severity, file:line, problem code, fix code

### Mode B: Project Diagnostic Report (full scan)

Trigger: "performance diagnostic", "generate report", or similar.

**Step 0 — Language & output file:**
Determine language. Report saved as `{project-name} {YYYY-MM-DD} {HH-mm-ss}.md` in project root.

**Step 1 — Full project scan (all file types):**
Run the file-size scan commands from `scripts/scan-project.ps1` or inline equivalent. Report each category with file count and size (MB).

**Step 2 — Metric collection (source code only, use `rg`):**
```
rg -c "shallowRef" src/ -g "*.vue" -g "*.ts"
rg -l "from ['\"]cesium|Cesium\.Viewer|new Cesium" src/ -g "*.vue" -g "*.ts"
rg -c "addEventListener" src/ -g "*.vue" -g "*.ts"
rg -c "removeEventListener" src/ -g "*.vue" -g "*.ts"
rg -c "setInterval|setTimeout" src/ -g "*.vue" -g "*.ts"
rg -c "onUnmounted|onBeforeUnmount" src/ -g "*.vue" -g "*.ts"
rg -c "\.destroy\(\)" src/ -g "*.vue" -g "*.ts"
```
Also find largest source files (>30KB):
```
Get-ChildItem -Path "src" -Recurse -Include "*.vue" -File | Where-Object { $_.Length -gt 30000 } | Sort-Object Length -Descending | Select-Object -First 10
```

**Step 3 — Rule matching (two-pass, DO NOT bulk-load rules):**

*Pass 1 — Detection scan:* Load `rules/_sections.md` only. It contains detection patterns for every rule. Run each pattern against the project. Record which rules have matches.

*Pass 2 — Confirm violations:* Load ONLY the rule files whose detection patterns returned matches. For each loaded rule, apply its full criteria to confirm true violations and collect file:line references.

Skip any rule whose detection pattern returned zero matches.

**Step 4 — Generate & save report:**
1. Load the selected language template from `references/report-template-{lang}.md`
2. Load term mappings from `references/i18n.md` (only now, for the final report)
3. Fill all fields with collected data
4. Save as `{project-name} {YYYY-MM-DD} {HH-mm-ss}.md` in project root
5. Output a summary in chat with the file path

## Rule Files

All rules in `rules/`. See `rules/_sections.md` for overview with detection patterns, `rules/_template.md` for format. Each rule file is self-contained: load only when its detection pattern matches.
