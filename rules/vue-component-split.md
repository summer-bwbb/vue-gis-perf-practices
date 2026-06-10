---
title: Split Oversized Vue Components
impact: MEDIUM-HIGH
impactDescription: Improves HMR speed 3-5x, reduces initial JS by 40-60%, improves maintainability
tags: vue, component, split, size, async, lazy
---

## Split Oversized Vue Components

**Impact: MEDIUM-HIGH — files over 30KB hurt HMR, initial load, and code comprehension**

**Thresholds:** < 15KB acceptable | 15-30KB consider splitting | 30-50KB should split | > 50KB must split.

**Violation pattern:** Any `.vue` file over 30KB.

**Fix pattern:** Extract logical template boundaries (tabs, panels, dialogs, sub-sections) into child components. Use `defineAsyncComponent` for conditionally rendered sections:
```ts
const RouteEditPreview = defineAsyncComponent(() => import('./RouteEditPreview.vue'))
```

**Why:** Vite's HMR recompiles the entire SFC on change. `defineAsyncComponent` splits child into separate chunk loaded only when needed. Smaller components are easier to test and review.

**Detection:**
```
Get-ChildItem -Path "src" -Recurse -Include "*.vue" -File | Where-Object { $_.Length -gt 30000 } | Sort-Object Length -Descending
```

**Auto-fix:** Identify logical boundaries. Extract each into child component. Pass state via props/emits or composable. Use `defineAsyncComponent` for conditional sections.
