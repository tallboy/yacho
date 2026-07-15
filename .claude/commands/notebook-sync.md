---
name: notebook-sync
description: "Weekly review + audit. Checks north star alignment and milestone progress, then audits for staleness, broken links, and status drift. Read-only — surfaces candidates for review, makes no changes."
allowed-tools: Read Glob Grep
---

`$ARGUMENTS`

Optional argument: number of days to consider a document stale (default: 14), or `full` to force a deep hygiene audit. Examples: `/notebook-sync`, `/notebook-sync 7`, `/notebook-sync full`

Parse the argument. If it's a number, use it as STALE_DAYS. If it's `full`, set FULL_AUDIT=true and STALE_DAYS=14. Otherwise, default STALE_DAYS=14.

Do NOT create, edit, or delete any files. Only read and report.

---

## Step 0 — North Star Review (always runs)

Read `.claude/memory/north_star.md` if it exists.

Find the most recent weekly doc and the priority tracker.

From these three sources, produce a brief coaching summary:

1. **North star:** Restate the user's 6–12 month goal in one sentence.
2. **Milestone check:** What is the nearest milestone or deadline visible in the tracker or weekly? How many days away is it?
3. **Progress pulse:** Summarize the current P0/P1 status — how many items are done `[x]`, in progress `[~]`, and not started `[ ]`?
4. **On track?** Based on the above, give a one-sentence honest read: are they on pace, behind, or ahead?

Format this as a short block at the top of the report — conversational, not bureaucratic. If no north star memory exists, skip the goal line and just report milestone + progress.

---

## Step 1 — Inventory

Find all `.md` files in the repository, excluding `.git/`, `.obsidian/`, and `node_modules/` directories. For each file, extract YAML frontmatter fields: `status`, `updated`, `type`, `project`. Skip any file whose `status` is `archived` or whose path contains an `archive`/`archived` directory segment.

Build an in-memory inventory of every non-archived markdown file with its path, frontmatter fields, and last-updated date (from `updated:` frontmatter or inline `**Last updated:**` text).

---

## Step 2 — Stale Document Detection

Flag any file where:
- `status` is `active`, `in-progress`, `draft`, or similar non-terminal value, AND
- The `updated:` date is older than STALE_DAYS, OR no date is present at all

Group flagged files by `project` frontmatter (use "Uncategorized" if missing). Sort groups by stalest-first.

---

## Step 3 — Status Drift

Find all files with `type: tracker` frontmatter. For each:
1. Find the most recent weekly document (by filename or `week:` field).
2. Compare `[~]` in-progress items in the tracker against completed/not-started items in the weekly. Flag conflicts.
3. Check any `[[wiki-links]]` in the tracker — flag unresolvable targets.

---

## Step 4 — Weekly Log Continuity

Find all files with `type: weekly` frontmatter. Sort by filename or `week:` field.

Check for gaps in the sequence. In the second-to-last weekly, find items marked `[ ]` that don't appear in the most recent weekly — flag these as dropped without explanation.

---

## Step 5 — Broken Wiki-Links

Scan every non-archived markdown file for `[[wiki-links]]`. For each link:
1. Try to resolve as a filename match anywhere in the repository (case-insensitive, with or without `.md`).
2. Try to resolve as a relative path from the linking file's directory.
3. Flag unresolved links with source file and line number.

---

## Step 6 — Working Preferences Check

Count the number of weekly docs found in Step 4.

If there are **3 or more**, add the following prompt at the end of the report:

> **Working preferences check**
> You've been using this notebook for a few weeks. Is there anything about how I'm working with you that you'd like to change? Any habits I've developed that aren't serving you? Tell me and I'll save it as a feedback memory so it applies from here on.

Skip this section entirely if fewer than 3 weekly docs exist.

---

## Report Format

Output a single prioritized report. Omit sections with no findings entirely (except Step 0, which always appears).

```
# Notebook Sync — [today's date]

## Where You Are
[Step 0 north star + milestone + progress pulse — 3-5 sentences]

## Stale Documents
- [ ] path/to/file.md — last updated YYYY-MM-DD ([N] days ago)

## Status Drift
- [ ] "Item text" — [~] in tracker but [x] in weekly-NN

## Weekly Gaps
- [ ] [description of gap or dropped item]

## Broken Links
- [ ] source/file.md:42 → [[broken-target]] — not found

---
[Working preferences check — only if 3+ weeklies]

---
Scanned N files. Flagged N items for review.
```

Keep the report tight — actionable in under 5 minutes.

**Reminder: read-only. Make no changes to any files.**
