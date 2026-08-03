---
name: repo-progress
description: "Generate a shareable progress report — a checkbox-completion gauge parsed from a tracker/PRD/TODO file, plus optional git/gh activity (commits, merged PRs, closed issues) if the target is a code repo. Read-only."
allowed-tools: Read Glob Grep Bash(git log:*) Bash(git diff:*) Bash(gh issue list:*) Bash(gh pr list:*)
---

`$ARGUMENTS`

Arguments (space-separated, any order):
- A file path (tracker, PRD, TODO — anything with `[ ]`/`[~]`/`[x]`/`[-]` checkboxes), OR a repo path/name
- `--days N` — activity window for git/gh mode (default: 7)
- `--author NAME` — filter commits/PRs/issues to one author

Examples: `/repo-progress priority-tracker.md`, `/repo-progress ~/code/yacho --days 1`, `/repo-progress ~/code/yacho --days 7 --author tallboy`

If no path is given, use the current directory and try both modes (checkbox gauge on any tracker-shaped file found, plus git/gh activity if it's a repo).

This produces one clean markdown report meant to be pasted into a status update — a weekly review, a Teams message, a standup note. It does not edit anything.

---

## Mode A — Checkbox Completion Gauge

Runs when the target is a markdown file (or the current directory contains one) with `type: tracker` frontmatter, or a filename matching `*priority-tracker*`, `*PRD*`, `*TODO*`, or `*weekly*`.

1. Read the file. Find every line matching `- [ ]`, `- [~]`, `- [x]`, `- [-]` (case-insensitive `x`).
2. Group by the nearest preceding heading (`##` or `###`) — this is usually a priority tier (P0/P1/P2) or a day-of-week section.
3. Per group and overall, compute:
   - Done: `[x]` count
   - In progress: `[~]` count
   - Not started: `[ ]` count
   - Cancelled: `[-]` count (exclude from the completion % — cancelled isn't incomplete, it's moot)
4. Completion % = `done / (done + in_progress + not_started)`, rounded to nearest integer.
5. Render an ASCII gauge, 20 characters wide: `█` for each 5% complete, `░` for the remainder. E.g. 65% → `[█████████████░░░░░░░]  65%`

## Mode B — Git/GH Activity

Runs when the target is a git repo (has a `.git` directory) and `git`/`gh` are available.

1. `git log --since="N days ago" [--author=NAME] --oneline` for commit count and headline list (cap at 10 shown, note total if more).
2. `git diff --shortstat HEAD@{N.days.ago}..HEAD` (or equivalent since-based diff) for lines added/removed — skip silently if the ref doesn't resolve (e.g. shallow clone).
3. If `gh` is authenticated for this host (check `gh auth status` once, don't retry on failure):
   - `gh pr list --state merged --search "merged:>=<date>"` (optionally `--author NAME`) — merged PRs in the window
   - `gh issue list --state closed --search "closed:>=<date>"` (optionally `--author NAME`) — closed issues in the window
4. If `gh` isn't authenticated or the repo has no remote, skip Mode B's PR/issue sections entirely and say so in one line — don't fail the whole report over it.

## Report Format

```
# Progress Report — [target name] — [date range]

## Completion
[███████████░░░░░░░░░]  XX% complete
Done: N · In progress: N · Not started: N · Cancelled: N (excluded)

### By section (if grouped)
- P0: [gauge] XX%
- P1: [gauge] XX%
- P2: [gauge] XX%

## Activity (last N days)  [only if git/gh mode ran]
- N commits, +X/-Y lines
- N PRs merged: [title (#N)](url), ...
- N issues closed: [title (#N)](url), ...

---
[one-line note on anything skipped, e.g. "gh not authenticated for this host — PR/issue data omitted"]
```

Keep it tight enough to paste directly into a status update without trimming. If both modes ran, Completion comes first (it's the "are we on track" signal), Activity second (it's the "here's what moved" evidence).

**This is read-only.** If the user wants a Teams/Outlook-formatted version of the output, suggest piping the report into `/compose`.
