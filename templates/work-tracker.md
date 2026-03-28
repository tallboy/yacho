---
type: work-tracker
project: "{{project-name}}"
status: active
issue: "{{issue number or link}}"
branch: "{{branch-name}}"
created: "{{YYYY-MM-DD}}"
updated: "{{YYYY-MM-DD}}"
---

# Work Tracker — {{short task description}}

## Context

**What:** {{One sentence describing the deliverable — what exists when this is done.}}

**Why:** {{Why this matters now. Link to the issue, request, or decision that triggered this work.}}

**Scope boundary:** {{What is explicitly out of scope for this task. Prevents creep.}}

---

## Implementation Steps

> [!tip] What makes a good atomic step
> - **Independently verifiable** — you can confirm it worked without completing other steps
> - **Small enough to finish in one session** — if it takes more than a few hours, break it down further
> - **Has a clear "done" signal** — a passing test, a visible output, a successful command
>
> Write steps so that someone else (or future you) could pick up from any step and continue.

---

### Step 1 — {{Action description}}

| | |
|---|---|
| **Status** | Not started / In progress / Done / Blocked |
| **Description** | {{What to do and any decisions embedded in this step}} |
| **Verification** | {{How to confirm it worked — e.g., "Run `npm test` — auth suite passes", "Navigate to /settings — new field appears"}} |
| **Files affected** | {{List files that will be created or modified}} |
| **Commit message** | `{{type(scope): description — e.g., feat(auth): add token refresh endpoint}}` |

---

### Step 2 — {{Action description}}

| | |
|---|---|
| **Status** | Not started / In progress / Done / Blocked |
| **Description** | {{What to do — reference output or artifacts from Step 1 if relevant}} |
| **Verification** | {{Concrete check — command, URL, visual confirmation}} |
| **Files affected** | {{List files}} |
| **Commit message** | `{{type(scope): description}}` |

---

### Step 3 — {{Action description}}

| | |
|---|---|
| **Status** | Not started / In progress / Done / Blocked |
| **Description** | {{What to do}} |
| **Verification** | {{How to confirm}} |
| **Files affected** | {{List files}} |
| **Commit message** | `{{type(scope): description}}` |

> [!info] Add more steps as needed.
> Copy any step block above. Keep numbering sequential. If a step turns out to be too large, split it in place and renumber.

---

## Progress Log

Append notes as you work. Newest entry on top. This is your breadcrumb trail.

### {{YYYY-MM-DD HH:MM}}
- {{What you did, what happened, any decisions made}}
- {{Blockers hit, workarounds used, questions raised}}

### {{YYYY-MM-DD HH:MM}}
- {{Previous entry}}

---

## Final Checklist

Complete this before marking the task as done.

- [ ] All implementation steps marked Done
- [ ] Tests pass (unit, integration, or manual verification as appropriate)
- [ ] Documentation updated if behavior or interfaces changed
- [ ] Code reviewed or pair-reviewed
- [ ] Branch merged or PR submitted
- [ ] Related issues updated or closed
- [ ] No temporary workarounds left in place (or they are tracked separately)
