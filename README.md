# vue-gis-perf-practices

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Vue 3](https://img.shields.io/badge/Vue-3-42b883?logo=vue.js&logoColor=white)](https://vuejs.org/)
[![Cursor Skill](https://img.shields.io/badge/Cursor-Agent%20Skill-000000?logo=cursor&logoColor=white)](https://cursor.com/docs/context/skills)

**Languages / 语言 / 語言**

[English](#english) · [简体中文](#简体中文) · [繁體中文](#繁體中文)

---

<a id="english"></a>

## English

### Overview

**vue-gis-perf-practices** is a [Cursor Agent Skill](https://cursor.com/docs/context/skills) for **Vue 3 + GIS** projects. It provides structured performance rules, code review workflows, and full-project diagnostic reports for stacks that use **Cesium**, **OpenLayers**, **Three.js**, **ECharts**, **SSE/WebSocket**, and other heavy 3D/GIS libraries.

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

#### Cursor IDE

1. Clone this repository:

```bash
git clone https://github.com/summer-bwbb/vue-gis-perf-practices.git
```

2. Copy the skill folder into your Cursor skills directory:

```bash
# macOS / Linux
cp -r vue-gis-perf-practices ~/.cursor/skills/

# Windows (PowerShell)
Copy-Item -Recurse vue-gis-perf-practices "$env:USERPROFILE\.cursor\skills\"
```

3. In Cursor chat, invoke the skill explicitly or let it auto-trigger on performance-related requests.

#### Codex CLI

```bash
cp -r vue-gis-perf-practices ~/.codex/skills/
```

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
- [CesiumJS Best Practices](https://cesium.com/learn/cesiumjs-learn/cesiumjs-best-practices/)
- [Vite Performance Guide](https://vitejs.dev/guide/performance)
- [Vue Reactivity In Depth](https://vuejs.org/guide/extras/reactivity-in-depth.html#how-reactivity-works-in-vue)

### License

[MIT](LICENSE) © 2026 summer-bwbb

---

<a id="简体中文"></a>

## 简体中文

### 简介

**vue-gis-perf-practices** 是一个面向 **Vue 3 + GIS** 技术栈的 [Cursor Agent Skill](https://cursor.com/docs/context/skills)。它提供结构化的性能优化规则、代码审查工作流，以及全项目性能诊断报告，适用于使用 **Cesium**、**OpenLayers**、**Three.js**、**ECharts**、**SSE/WebSocket** 等重型 3D/GIS 库的项目。

Skill 采用 **先搜索、按需加载** 策略：不会一次性加载全部规则，而是根据代码中的实际模式，仅加载匹配的规则文件。

### 适用场景

| 触发方式 | 模式 |
|----------|------|
| 「审查代码」「检查性能」、PR 审查 | **模式 A** — 规则审查 |
| 「性能诊断」「生成报告」、全项目扫描 | **模式 B** — 项目诊断报告 |

报告与对话输出支持 **英文**、**简体中文 (zh)**、**繁体中文 (zh-TW)** 三种语言。

### 规则分类（18 条规则，9 大类）

| 分类 | 前缀 | 严重程度 | 关注点 |
|------|------|----------|--------|
| GIS 内存与实体管理 | `cesium-*` | 严重 | `shallowRef`、Viewer 生命周期、事件处理器清理 |
| 包体积优化 | `bundle-*` | 严重 | 手动分包、ECharts 按需引入、Element Plus 按需加载 |
| 实时连接管理 | `realtime-*` | 高 | SSE 生命周期、重连退避、优雅降级 |
| Vue 响应式优化 | `vue-*` | 中高 | 大对象 `shallowRef`、组件拆分、watch 清理 |
| API 与数据流 | `api-*` | 中高 | 组件卸载时取消请求（`AbortController`） |
| 渲染性能 | `render-*` | 中 | DOM 事件监听器清理 |
| 地图交互 | `map-*` | 中 | 地图事件节流 / 防抖 |
| JavaScript 通用 | `js-*` | 低中 | 定时器清理（`setInterval` / `setTimeout`） |
| 构建与部署 | `build-*` | 低 | Vite 构建配置（sourcemap、chunk 限制） |

### 工作模式

#### 模式 A — 规则审查（单文件 / PR）

1. 根据用户消息确定输出语言
2. 读取目标文件，识别 import 与代码模式
3. 加载 `rules/_sections.md`，匹配检测模式
4. **仅**加载匹配的规则文件并确认违规项
5. 输出：规则 ID、严重程度、文件:行号、问题代码、修复代码

#### 模式 B — 项目诊断报告

1. **扫描** — 运行文件体积扫描（`scripts/scan-project.ps1` 或等效命令）
2. **指标** — 通过 `rg` 收集计数（如 `shallowRef`、Cesium 引用、监听器、定时器、卸载钩子）
3. **规则匹配** — 两轮流程：检测扫描 → 确认违规（不批量加载规则）
4. **报告** — 填充对应语言模板，保存为 `{项目名} {YYYY-MM-DD} {HH-mm-ss}.md`

报告涵盖八个维度：GIS 内存管理、包体积、实时连接、Vue 响应式、事件生命周期、组件体积、API 数据流、构建配置。

### 安装

#### Cursor IDE

1. 克隆仓库：

```bash
git clone https://github.com/summer-bwbb/vue-gis-perf-practices.git
```

2. 将 skill 目录复制到 Cursor skills 目录：

```bash
# macOS / Linux
cp -r vue-gis-perf-practices ~/.cursor/skills/

# Windows (PowerShell)
Copy-Item -Recurse vue-gis-perf-practices "$env:USERPROFILE\.cursor\skills\"
```

3. 在 Cursor 对话中显式调用 skill，或在性能相关请求时让其自动触发。

#### Codex CLI

```bash
cp -r vue-gis-perf-practices ~/.codex/skills/
```

### 使用示例

```
用 vue-gis-perf-practices 审查 src/components/MapViewer.vue 的性能问题。
```

```
对项目进行完整性能诊断，生成中文报告。
```

```
Use vue-gis-perf-practices to run a full performance diagnostic and generate an English report.
```

### 项目结构

```
vue-gis-perf-practices/
├── SKILL.md                 # Skill 入口与工作流
├── metadata.json            # 版本与参考链接
├── rules/
│   ├── _sections.md         # 规则索引与检测模式（优先加载）
│   ├── _template.md         # 规则文件格式
│   ├── cesium-*.md          # GIS 内存规则
│   ├── bundle-*.md          # 包体积优化规则
│   ├── realtime-*.md        # SSE / WebSocket 规则
│   ├── vue-*.md             # Vue 响应式规则
│   └── ...                  # api、render、map、js、build
├── references/
│   ├── report-template-en.md
│   ├── report-template-zh.md
│   ├── report-template-zh-TW.md
│   └── i18n.md              # 多语言术语映射
├── scripts/
│   └── scan-project.ps1     # 项目文件体积扫描脚本
└── agents/
    └── openai.yaml          # Agent 界面配置
```

### 参考资源

- [Vue 性能最佳实践](https://vuejs.org/guide/best-practices/performance.html)
- [CesiumJS 最佳实践](https://cesium.com/learn/cesiumjs-learn/cesiumjs-best-practices/)
- [Vite 性能指南](https://vitejs.dev/guide/performance)
- [Vue 响应式原理](https://vuejs.org/guide/extras/reactivity-in-depth.html#how-reactivity-works-in-vue)

### 许可证

[MIT](LICENSE) © 2026 summer-bwbb

---

<a id="繁體中文"></a>

## 繁體中文

### 簡介

**vue-gis-perf-practices** 是一個面向 **Vue 3 + GIS** 技術棧的 [Cursor Agent Skill](https://cursor.com/docs/context/skills)。它提供結構化的效能優化規則、程式碼審查工作流，以及全專案效能診斷報告，適用於使用 **Cesium**、**OpenLayers**、**Three.js**、**ECharts**、**SSE/WebSocket** 等重型 3D/GIS 函式庫的專案。

Skill 採用 **先搜尋、按需載入** 策略：不會一次性載入全部規則，而是根據程式碼中的實際模式，僅載入匹配的規則檔案。

### 適用場景

| 觸發方式 | 模式 |
|----------|------|
| 「審查程式碼」「檢查效能」、PR 審查 | **模式 A** — 規則審查 |
| 「效能診斷」「產生報告」、全專案掃描 | **模式 B** — 專案診斷報告 |

報告與對話輸出支援 **英文**、**簡體中文 (zh)**、**繁體中文 (zh-TW)** 三種語言。

### 規則分類（18 條規則，9 大類）

| 分類 | 前綴 | 嚴重程度 | 關注點 |
|------|------|----------|--------|
| GIS 記憶體與實體管理 | `cesium-*` | 嚴重 | `shallowRef`、Viewer 生命週期、事件處理器清理 |
| 套件體積優化 | `bundle-*` | 嚴重 | 手動分包、ECharts 按需引入、Element Plus 按需載入 |
| 即時連線管理 | `realtime-*` | 高 | SSE 生命週期、重連退避、優雅降級 |
| Vue 響應式優化 | `vue-*` | 中高 | 大物件 `shallowRef`、元件拆分、watch 清理 |
| API 與資料流 | `api-*` | 中高 | 元件卸載時取消請求（`AbortController`） |
| 渲染效能 | `render-*` | 中 | DOM 事件監聽器清理 |
| 地圖互動 | `map-*` | 中 | 地圖事件節流 / 防抖 |
| JavaScript 通用 | `js-*` | 低中 | 定時器清理（`setInterval` / `setTimeout`） |
| 建構與部署 | `build-*` | 低 | Vite 建構配置（sourcemap、chunk 限制） |

### 工作模式

#### 模式 A — 規則審查（單檔案 / PR）

1. 根據使用者訊息確定輸出語言
2. 讀取目標檔案，識別 import 與程式碼模式
3. 載入 `rules/_sections.md`，匹配檢測模式
4. **僅**載入匹配的規則檔案並確認違規項
5. 輸出：規則 ID、嚴重程度、檔案:行號、問題程式碼、修復程式碼

#### 模式 B — 專案診斷報告

1. **掃描** — 執行檔案體積掃描（`scripts/scan-project.ps1` 或等效命令）
2. **指標** — 透過 `rg` 收集計數（如 `shallowRef`、Cesium 引用、監聽器、定時器、卸載鉤子）
3. **規則匹配** — 兩輪流程：檢測掃描 → 確認違規（不批量載入規則）
4. **報告** — 填充對應語言模板，儲存為 `{專案名} {YYYY-MM-DD} {HH-mm-ss}.md`

報告涵蓋八個維度：GIS 記憶體管理、套件體積、即時連線、Vue 響應式、事件生命週期、元件體積、API 資料流、建構配置。

### 安裝

#### Cursor IDE

1. 克隆倉庫：

```bash
git clone https://github.com/summer-bwbb/vue-gis-perf-practices.git
```

2. 將 skill 目錄複製到 Cursor skills 目錄：

```bash
# macOS / Linux
cp -r vue-gis-perf-practices ~/.cursor/skills/

# Windows (PowerShell)
Copy-Item -Recurse vue-gis-perf-practices "$env:USERPROFILE\.cursor\skills\"
```

3. 在 Cursor 對話中顯式呼叫 skill，或在效能相關請求時讓其自動觸發。

#### Codex CLI

```bash
cp -r vue-gis-perf-practices ~/.codex/skills/
```

### 使用範例

```
使用 vue-gis-perf-practices 審查 src/components/MapViewer.vue 的效能問題。
```

```
對專案進行完整效能診斷，產出繁體中文報告。
```

```
Use vue-gis-perf-practices to run a full performance diagnostic and generate an English report.
```

### 專案結構

```
vue-gis-perf-practices/
├── SKILL.md                 # Skill 入口與工作流
├── metadata.json            # 版本與參考連結
├── rules/
│   ├── _sections.md         # 規則索引與檢測模式（優先載入）
│   ├── _template.md         # 規則檔案格式
│   ├── cesium-*.md          # GIS 記憶體規則
│   ├── bundle-*.md          # 套件體積優化規則
│   ├── realtime-*.md        # SSE / WebSocket 規則
│   ├── vue-*.md             # Vue 響應式規則
│   └── ...                  # api、render、map、js、build
├── references/
│   ├── report-template-en.md
│   ├── report-template-zh.md
│   ├── report-template-zh-TW.md
│   └── i18n.md              # 多語言術語映射
├── scripts/
│   └── scan-project.ps1     # 專案檔案體積掃描腳本
└── agents/
    └── openai.yaml          # Agent 介面配置
```

### 參考資源

- [Vue 效能最佳實踐](https://vuejs.org/guide/best-practices/performance.html)
- [CesiumJS 最佳實踐](https://cesium.com/learn/cesiumjs-learn/cesiumjs-best-practices/)
- [Vite 效能指南](https://vitejs.dev/guide/performance)
- [Vue 響應式原理](https://vuejs.org/guide/extras/reactivity-in-depth.html#how-reactivity-works-in-vue)

### 授權條款

[MIT](LICENSE) © 2026 summer-bwbb
