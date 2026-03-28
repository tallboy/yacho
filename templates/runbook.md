---
title: "{{Runbook title — name the procedure, not the system}}"
project: "{{project-name}}"
created: "{{YYYY-MM-DD}}"
updated: "{{YYYY-MM-DD}}"
status: active
type: runbook
---

# {{Runbook Title}}

| | |
|---|---|
| **When to use** | {{Trigger condition — e.g., "Every release", "When a customer reports X", "Before demo day"}} |
| **Time needed** | {{Realistic estimate including verification — e.g., "15-20 min first time, 5 min once familiar"}} |
| **Prerequisites** | {{What must be true before starting — access, tools installed, environment state}} |

> [!info] Follow the steps in order.
> Each step includes an expected result. If reality does not match the expected result, stop and check the troubleshooting section before continuing.

---

## Pre-Flight Checklist

Confirm these before starting. Do not skip items to save time — that is how incidents happen.

- [ ] {{Access confirmed — you can reach [system/environment/repo]}}
- [ ] {{Required tool installed and correct version — e.g., `tool --version` returns X.Y+}}
- [ ] {{Environment variable or config set — e.g., `.env` has `KEY=value`}}
- [ ] {{Backups or snapshots taken if this procedure is destructive}}
- [ ] {{Relevant people notified if this affects shared resources}}

---

## Steps

### Step 1 — {{Action title}}

**Action:**
{{Describe what to do. Be explicit — include the exact command, UI path, or API call. Do not assume the reader knows shortcuts.}}

```bash
{{command if applicable}}
```

**Expected result:**
{{What you should see after this step — output, status change, confirmation message.}}

> [!tip] {{Optional note — common gotcha, timing consideration, or alternative approach.}}

---

### Step 2 — {{Action title}}

**Action:**
{{Next step. Reference output from Step 1 if needed.}}

```bash
{{command if applicable}}
```

**Expected result:**
{{What confirms this step succeeded.}}

---

### Step 3 — {{Action title}}

**Action:**
{{Continue the procedure.}}

**Expected result:**
{{Expected outcome.}}

> [!info] {{Optional note — e.g., "This step can take up to 5 minutes. Do not cancel early."}}

---

### Step 4 — {{Action title}}

**Action:**
{{Final step or wrap-up action.}}

**Expected result:**
{{How you know the entire procedure succeeded.}}

---

## If Something Goes Wrong

| Problem | Fix |
|---------|-----|
| {{Step fails with error X}} | {{Exact recovery steps — do not just say "retry"}} |
| {{Process hangs or times out}} | {{How to safely cancel and what state to expect afterward}} |
| {{Unexpected output or partial success}} | {{How to diagnose and whether it is safe to continue}} |
| {{Permission denied}} | {{Who to contact or what access to request}} |

> [!tip] If the problem is not listed here, do not improvise on production systems.
> Document the new failure mode after resolving it and add it to this table.

---

## Post-Run Validation

Run through these checks after completing the procedure to confirm everything is clean.

| Check | Pass / Fail | Notes |
|-------|-------------|-------|
| {{Primary success criterion — e.g., service responds on /health}} | | |
| {{Secondary check — e.g., logs show no errors in last 5 min}} | | |
| {{Data integrity — e.g., record count matches expected}} | | |
| {{Downstream systems — e.g., dependent service still healthy}} | | |
| {{Cleanup — e.g., temp files removed, debug flags off}} | | |

---

## Revision History

| Date | Change | Author |
|------|--------|--------|
| {{YYYY-MM-DD}} | {{Initial version}} | {{Name}} |
| {{YYYY-MM-DD}} | {{What changed and why — e.g., "Added Step 3b after incident #12"}} | {{Name}} |
