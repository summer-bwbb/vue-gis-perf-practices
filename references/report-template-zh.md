# 性能诊断报告

**项目**: {project_name}
**扫描时间**: {YYYY-MM-DD HH:mm}
**技术栈**: {detected_stack}
**源文件数**: {file_count}

---

## 一、总体评级

| 维度 | 评级 | 说明 |
|------|------|------|
| GIS 内存管理 | {emoji} {grade} | {summary} |
| 包体积优化 | {emoji} {grade} | {summary} |
| 实时连接管理 | {emoji} {grade} | {summary} |
| Vue 响应式 | {emoji} {grade} | {summary} |
| 事件生命周期 | {emoji} {grade} | {summary} |
| 组件体积 | {emoji} {grade} | {summary} |
| API 数据流 | {emoji} {grade} | {summary} |
| 构建配置 | {emoji} {grade} | {summary} |

**综合评级**: {emoji} **{overall_grade}** — {one_line_summary}

> 评级标准: A (优秀) / B (良好) / C (需改进) / D (较差) / F (严重)
> 标识: 🟢 B+ 及以上 / 🟡 C 区间 / 🔴 D 及以下

---

## 二、关键指标

| 指标 | 当前值 | 基准值 | 状态 |
|------|--------|--------|------|
| 超过 30KB 的 Vue 文件 | {count} | 0 | {pass/fail} |
| 最大单文件体积 | {size} | < 30KB | {pass/fail} |
| 引用 Cesium 的文件数 | {count} | — | 信息 |
| 使用 shallowRef 的文件数 | {count} | ≈ Cesium 文件数 | {pass/fail} |
| addEventListener 调用数 | {count} | = removeEventListener | {pass/fail} |
| removeEventListener 调用数 | {count} | — | 信息 |
| setInterval/setTimeout 调用数 | {count} | 尽量少 | 信息 |
| onUnmounted/onBeforeUnmount 数 | {count} | — | 信息 |
| .destroy() 调用数 | {count} | — | 信息 |

---

## 三、发现的问题（按严重程度排序）

### 🔴 严重 (Critical)

| 编号 | 规则 | 文件 | 问题描述 |
|------|------|------|----------|
| C-01 | {rule_id} | `{file}:{line}` | {description} |
| C-02 | ... | ... | ... |

**修复建议**: {fix_description}

### 🟡 警告 (Warning)

| 编号 | 规则 | 文件 | 问题描述 |
|------|------|------|----------|
| W-01 | {rule_id} | `{file}:{line}` | {description} |

**修复建议**: {fix_description}

### 🔵 建议 (Info)

| 编号 | 规则 | 文件 | 问题描述 |
|------|------|------|----------|
| I-01 | {rule_id} | `{file}:{line}` | {description} |

**修复建议**: {fix_description}

---

## 四、风险矩阵

| 风险项 | 发生概率 | 影响程度 | 风险等级 | 关联问题 |
|--------|----------|----------|----------|----------|
| {risk_description} | {高/中/低} | {严重/高/中} | {emoji} | C-01, W-02 |
| ... | ... | ... | ... | ... |

---

## 五、优化路线图

### 第一阶段：止血（1-2 天）
1. {action} → 对应 {finding_id}
2. {action} → 对应 {finding_id}

### 第二阶段：瘦身（3-5 天）
3. {action} → 对应 {finding_id}
4. {action} → 对应 {finding_id}

### 第三阶段：提速（1 周）
5. {action} → 对应 {finding_id}
6. {action} → 对应 {finding_id}

---

## 六、检查清单

| 序号 | 检查项 | 状态 | 文件 | 备注 |
|------|--------|------|------|------|
| 1 | Cesium Viewer 使用 shallowRef | ✅/❌ | `{file}` | {note} |
| 2 | SSE 连接在页面离开时关闭 | ✅/❌ | `{file}` | {note} |
| 3 | EventListener 有对应的清理 | ✅/❌ | `{file}` | {note} |
| 4 | 定时器在 onUnmounted 中清除 | ✅/❌ | `{file}` | {note} |
| 5 | 大组件已拆分至 < 30KB | ✅/❌ | `{file}` | {note} |
| 6 | 包体积已合理拆分 | ✅/❌ | `{file}` | {note} |
| 7 | API 请求在卸载时取消 | ✅/❌ | `{file}` | {note} |
| 8 | 地图事件已节流/防抖 | ✅/❌ | `{file}` | {note} |
| 9 | ECharts 按需引入 | ✅/❌ | `{file}` | {note} |
| 10 | Element Plus 按需引入 | ✅/❌ | `{file}` | {note} |

---

*由 vue-gis-perf-practices 技能生成*