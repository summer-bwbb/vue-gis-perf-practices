# vue-gis-perf-practices

[![Agent Skill](https://img.shields.io/badge/Agent-Skill-6366f1)](https://cursor.com/docs/context/skills)
[![Vue 3](https://img.shields.io/badge/Vue-3-42b883?logo=vue.js&logoColor=white)](https://vuejs.org/)
[![GIS](https://img.shields.io/badge/GIS-3D%20%26%20Mapping-2ea043)](https://en.wikipedia.org/wiki/Geographic_information_system)
[![Cesium](https://img.shields.io/badge/Cesium-JS-6CADFF?logo=cesium&logoColor=white)](https://cesium.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Languages / 语言 / 語言**

[English](README.md) · **简体中文** · [繁體中文](README.zh-TW.md)

---

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
- [CesiumJS 开发指南（含性能与最佳实践）](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md)
- [Vite 性能指南](https://vitejs.dev/guide/performance)
- [Vue 响应式原理](https://vuejs.org/guide/extras/reactivity-in-depth.html#how-reactivity-works-in-vue)

### 许可证

[MIT](LICENSE) © 2026 summer-bwbb
