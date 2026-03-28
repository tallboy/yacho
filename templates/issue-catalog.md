---
title: "Issue Catalog — {{project-name}}"
project: "{{project-name}}"
created: "{{YYYY-MM-DD}}"
updated: "{{YYYY-MM-DD}}"
status: active
type: issue-catalog
---

# Issue Catalog — {{project-name}}

> [!info] How to use this file
> Log issues as they happen, in chronological order. Be specific about symptoms and root causes — vague entries are useless later. The summary table at the bottom is your quick-scan view; keep it in sync with the entries above.

---

## Issues

---

### Issue #1 — {{short descriptive title}}

| Field | Detail |
|-------|--------|
| **Date** | {{YYYY-MM-DD}} |
| **Phase** | {{When in the workflow this occurred — e.g., build, deploy, testing, runtime, onboarding}} |
| **Symptom** | {{What you observed. Be literal: error messages, unexpected behavior, incorrect output.}} |
| **Root Cause** | {{Why it happened. If unknown, say "Under investigation" and update later.}} |
| **Resolution** | {{Exact steps taken to fix it. Include commands, config changes, or links to commits.}} |
| **Impact** | {{Time lost, scope affected, downstream consequences. Be honest.}} |
| **Prevention** | {{What would prevent this from happening again — automation, docs, checklist item, guard rail.}} |

---

### Issue #2 — {{short descriptive title}}

| Field | Detail |
|-------|--------|
| **Date** | {{YYYY-MM-DD}} |
| **Phase** | {{Phase}} |
| **Symptom** | {{What you observed}} |
| **Root Cause** | {{Why}} |
| **Resolution** | {{How fixed}} |
| **Impact** | {{Time lost, scope}} |
| **Prevention** | {{How to avoid next time}} |

---

### Issue #3 — {{short descriptive title}}

| Field | Detail |
|-------|--------|
| **Date** | {{YYYY-MM-DD}} |
| **Phase** | {{Phase}} |
| **Symptom** | {{What you observed}} |
| **Root Cause** | {{Why}} |
| **Resolution** | {{How fixed}} |
| **Impact** | {{Time lost, scope}} |
| **Prevention** | {{How to avoid next time}} |

> [!tip] Copy the block above to add new issues.
> Keep the numbering sequential. If an issue recurs, reference the original by number and note what changed.

---

## Summary

| # | Issue | Date | Time Lost | Avoidable? | Prevention In Place? |
|---|-------|------|-----------|------------|---------------------|
| 1 | {{Short title}} | {{Date}} | {{e.g., 2h}} | {{Yes / No / Partially}} | {{Yes / No — link to action if Yes}} |
| 2 | {{Short title}} | {{Date}} | {{Time}} | {{Yes / No}} | {{Yes / No}} |
| 3 | {{Short title}} | {{Date}} | {{Time}} | {{Yes / No}} | {{Yes / No}} |

---

## Open Items

Issues that are resolved but whose prevention steps are not yet in place.

- [ ] {{Issue #X — implement [prevention measure]. Owner: [name]. Target: [date]}}
- [ ] {{Issue #X — add [guard rail or automation]. Owner: [name]. Target: [date]}}
- [ ] {{Issue #X — document [procedure] so this does not rely on tribal knowledge}}
