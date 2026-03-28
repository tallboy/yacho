---
type: tracker
project: "{{project-name}}"
status: active
updated: "{{YYYY-MM-DD}}"
---

# Priority Tracker — {{project-name}}

> [!info] How to use this file
> Update at the start or end of each work session. Move items between tiers as priorities shift. The goal is to always know what matters most without rereading everything.

---

## P0 — Must happen before next milestone

These are non-negotiable. If the milestone lands and these are not done, something went wrong.

- [ ] {{Describe the deliverable, not the activity. "API auth working end-to-end" not "work on auth"}}
- [ ] {{Include a due date or trigger: "before demo on March 15" or "before PR merge"}}
- [ ] {{If blocked, say so here — do not bury it}}

> [!tip] P0 should have 1-3 items max.
> If you have more than three P0 items, you either need to renegotiate scope or break them into smaller pieces.

---

## P1 — Important, in progress

Active work that supports current goals. These become P0 when the current P0 items clear.

- [ ] {{Task with enough context to resume cold — what, why, and current state}}
- [ ] {{Task — note any dependencies or people involved}}
- [ ] {{Task — link to related issue, PR, or document if one exists}}

---

## P2 — Ideas surfaced, pending direction

Things that came up during work that are worth capturing but not worth doing yet. Review these weekly.

- [ ] {{Idea or improvement — note where it came from}}
- [ ] {{Question that needs research before it becomes actionable}}
- [ ] {{Optimization or refactor that is not urgent but would pay off}}

---

## P3 — Backlog / Blocked

Parked intentionally. Either waiting on external input or deliberately deferred.

- [ ] {{Item — blocked by: [person/event/decision]. Last checked: [date]}}
- [ ] {{Item — deferred until [condition]. Revisit: [date]}}
- [ ] {{Item — nice to have, no current priority}}

---

## Decisions Waiting

| Decision | Owner | Waiting Since | Context |
|----------|-------|---------------|---------|
| {{What needs to be decided}} | {{Who makes the call}} | {{YYYY-MM-DD}} | {{Link or one-line summary of why this is stalled}} |
| {{Decision}} | {{Owner}} | {{Date}} | {{Context}} |

> [!tip] Stale decisions are silent blockers.
> If anything in this table is older than two weeks, escalate it or make the decision yourself with a documented rationale.

---

## Session Notes

Update this each time you touch the tracker. Newest entry on top.

### {{YYYY-MM-DD}}
- {{What changed: items moved, completed, added, or blocked}}
- {{Any context that future-you will need}}

### {{YYYY-MM-DD}}
- {{Previous session notes}}
