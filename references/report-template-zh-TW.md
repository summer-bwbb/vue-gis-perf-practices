# 性能診斷報告

**專案**: {project_name}
**掃描時間**: {YYYY-MM-DD HH:mm}
**技術堆疊**: {detected_stack}
**原始檔數**: {file_count}

---

## 一、總體評級

| 維度 | 說明 |
|------|------|
| GIS 記憶體管理 | {emoji} {grade} | {summary} |
| 套件體積優化 | {emoji} {grade} | {summary} |
| 即時連線管理 | {emoji} {grade} | {summary} |
| Vue 響應式 | {emoji} {grade} | {summary} |
| 事件生命週期 | {emoji} {grade} | {summary} |
| 元件體積 | {emoji} {grade} | {summary} |
| API 資料流 | {emoji} {grade} | {summary} |
| 建構配置 | {emoji} {grade} | {summary} |

**綜合評級**: {emoji} **{overall_grade}** — {one_line_summary}

> 評級標準: A (優秀) / B (良好) / C (需改進) / D (較差) / F (嚴重)
> 標識: 🟢 B+ 及以上 / 🟡 C 區間 / 🔴 D 及以下

---

## 二、關鍵指標

| 指標 | 當前值 | 基準值 | 狀態 |
|------|--------|--------|------|
| 超過 30KB 的 Vue 檔案 | {count} | 0 | {pass/fail} |
| 最大單檔體積 | {size} | < 30KB | {pass/fail} |
| 引用 Cesium 的檔案數 | {count} | — | 資訊 |
| 使用 shallowRef 的檔案數 | {count} | ≈ Cesium 檔案數 | {pass/fail} |
| addEventListener 呼叫數 | {count} | = removeEventListener | {pass/fail} |
| removeEventListener 呼叫數 | {count} | — | 資訊 |
| setInterval/setTimeout 呼叫數 | {count} | 盡量少 | 資訊 |
| onUnmounted/onBeforeUnmount 數 | {count} | — | 資訊 |
| .destroy() 呼叫數 | {count} | — | 資訊 |

---

## 三、發現的問題（按嚴重程度排序）

### 🔴 嚴重 (Critical)

| 編號 | 規則 | 檔案 | 問題描述 |
|------|------|------|----------|
| C-01 | {rule_id} | `{file}:{line}` | {description} |
| C-02 | ... | ... | ... |

**修復建議**: {fix_description}

### 🟡 警告 (Warning)

| 編號 | 規則 | 檔案 | 問題描述 |
|------|------|------|----------|
| W-01 | {rule_id} | `{file}:{line}` | {description} |

**修復建議**: {fix_description}

### 🔵 建議 (Info)

| 編號 | 規則 | 檔案 | 問題描述 |
|------|------|------|----------|
| I-01 | {rule_id} | `{file}:{line}` | {description} |

**修復建議**: {fix_description}

---

## 四、風險矩陣

| 風險項 | 發生機率 | 影響程度 | 風險等級 | 關聯問題 |
|--------|----------|----------|----------|----------|
| {risk_description} | {高/中/低} | {嚴重/高/中} | {emoji} | C-01, W-02 |
| ... | ... | ... | ... | ... |

---

## 五、優化路線圖

### 第一階段：止血（1-2 天）
1. {action} → 對應 {finding_id}
2. {action} → 對應 {finding_id}

### 第二階段：瘦身（3-5 天）
3. {action} → 對應 {finding_id}
4. {action} → 對應 {finding_id}

### 第三階段：提速（1 週）
5. {action} → 對應 {finding_id}
6. {action} → 對應 {finding_id}

---

## 六、檢查清單

| 序號 | 檢查項 | 狀態 | 檔案 | 備註 |
|------|--------|------|------|------|
| 1 | Cesium Viewer 使用 shallowRef | ✅/❌ | `{file}` | {note} |
| 2 | SSE 連線在頁面離開時關閉 | ✅/❌ | `{file}` | {note} |
| 3 | EventListener 有對應的清理 | ✅/❌ | `{file}` | {note} |
| 4 | 計時器在 onUnmounted 中清除 | ✅/❌ | `{file}` | {note} |
| 5 | 大元件已拆分至 < 30KB | ✅/❌ | `{file}` | {note} |
| 6 | 套件體積已合理拆分 | ✅/❌ | `{file}` | {note} |
| 7 | API 請求在卸載時取消 | ✅/❌ | `{file}` | {note} |
| 8 | 地圖事件已節流/防抖 | ✅/❌ | `{file}` | {note} |
| 9 | ECharts 按需引入 | ✅/❌ | `{file}` | {note} |
| 10 | Element Plus 按需引入 | ✅/❌ | `{file}` | {note} |

---

*由 vue-gis-perf-practices 技能生成*