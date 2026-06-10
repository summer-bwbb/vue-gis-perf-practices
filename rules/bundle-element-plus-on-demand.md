---
title: Import Element Plus Components on Demand
impact: CRITICAL
impactDescription: Reduces Element Plus bundle from ~800KB to ~150KB
tags: bundle, element-plus, tree-shake, import, unplugin-vue-components
---

## Import Element Plus Components on Demand

**Impact: CRITICAL — full Element Plus import adds ~800KB unused code**

Without auto-import, importing the full library pulls in every component, directive, and locale.

**Violation pattern:** `import ElementPlus from 'element-plus'` + `app.use(ElementPlus)` in `main.ts`.

**Fix pattern (auto-import, recommended):**
```ts
// vite.config.ts
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import AutoImport from 'unplugin-auto-import/vite'
// Add to plugins: AutoImport({ resolvers: [ElementPlusResolver()] }), Components({ resolvers: [ElementPlusResolver()] })
```
Then remove `import ElementPlus` and `app.use(ElementPlus)` from `main.ts`.

**Detection:**
```
rg "import ElementPlus|from ['\"]element-plus['\"]|app\.use\(ElementPlus\)" src/ -g "*.ts"
rg "unplugin-vue-components|ElementPlusResolver" vite.config.ts
```

**Auto-fix:** Install `unplugin-vue-components` and `unplugin-auto-import` if not present. Add Vite plugin config. Remove full import and `app.use()` from `main.ts`.
