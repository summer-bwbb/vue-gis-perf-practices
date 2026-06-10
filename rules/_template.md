---
title: Rule Title Here
impact: MEDIUM
impactDescription: Optional description of impact (e.g., "2-10x improvement")
tags: tag1, tag2, tag3
---

## Rule Title Here

**Impact: MEDIUM (optional impact description)**

Brief explanation of the rule and why it matters for Vue + GIS projects.

**Incorrect:**

```vue
<script setup lang="ts">
// Bad code example — include realistic Vue 3 + GIS code
const viewer = ref(null) // problem: ref wraps Cesium Viewer
</script>
```

**Correct:**

```vue
<script setup lang="ts">
// Good code example — show the proper pattern
const viewer = shallowRef(null) // shallowRef avoids deep Proxy
</script>
```

**Why:**
- Reason 1 (specific to Cesium/GIS/Vue 3)
- Reason 2 (performance impact)

**Detection:**
```
# rg pattern to find violations
rg "pattern" src/ -g "*.vue" -g "*.ts"
```

**Auto-fix guidance:**
Describe how an agent should automatically fix this issue.
