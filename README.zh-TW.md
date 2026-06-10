# vue-gis-perf-practices

[![Agent Skill](https://img.shields.io/badge/Agent-Skill-6366f1)](SKILL.md)
[![Vue 3](https://img.shields.io/badge/Vue-3-42b883?logo=vue.js&logoColor=white)](https://vuejs.org/)
[![GIS](https://img.shields.io/badge/GIS-3D%20%26%20Mapping-2ea043)](https://en.wikipedia.org/wiki/Geographic_information_system)
[![Cesium](https://img.shields.io/badge/Cesium-JS-6CADFF?logo=cesium&logoColor=white)](https://cesium.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Languages / 语言 / 語言**

[English](README.md) · [简体中文](README.zh-CN.md) · **繁體中文**

---

### 簡介

**vue-gis-perf-practices** 是一個面向 **Vue 3 + GIS** 技術棧的 **Agent Skill**。它遵循標準 Agent Skills 格式（以 `SKILL.md` 為入口、按需載入規則），可在任何支援 skills 的 AI 程式設計助手中使用。它提供結構化的效能優化規則、程式碼審查工作流，以及全專案效能診斷報告，適用於使用 **Cesium**、**OpenLayers**、**Three.js**、**ECharts**、**SSE/WebSocket** 等重型 3D/GIS 函式庫的專案。

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

1. 克隆倉庫：

```bash
git clone https://github.com/summer-bwbb/vue-gis-perf-practices.git
```

2. 將整個 `vue-gis-perf-practices` 資料夾複製到你的 Agent 的 skills 目錄，具體路徑請參閱所使用 Agent 的文件。

```bash
cp -r vue-gis-perf-practices /path/to/your/agent/skills/
```

3. 透過 skill 名稱或效能相關請求呼叫——Agent 會載入 `SKILL.md` 並自動套用匹配的規則。

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
- [CesiumJS 開發指南（含效能與最佳實踐）](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md)
- [Vite 效能指南](https://vitejs.dev/guide/performance)
- [Vue 響應式原理](https://vuejs.org/guide/extras/reactivity-in-depth.html#how-reactivity-works-in-vue)

### 授權條款

[MIT](LICENSE) © 2026 summer-bwbb
