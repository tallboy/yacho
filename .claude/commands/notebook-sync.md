---
name: notebook-sync
description: "Audit the notebook for staleness, broken cross-references, and status drift. Read-only — surfaces candidates for review, makes no changes."
allowed-tools: Read Glob Grep
---

Perform a read-only audit of this notebook (the repository root). Do NOT create, edit, or delete any files. Only read and report.

**Stale threshold:** $ARGUMENTS days (default to 14 if not provided or not a number).

## Step 1 — Inventory

Find all `.md` files in the repository, excluding `.git/`, `.obsidian/`, and `node_modules/` directories. For each file, extract YAML frontmatter fields: `status`, `updated`, `type`, `project`. Skip any file whose `status` frontmatter value is `archived` or whose path contains an `archive`/`archived` directory segment.

Build an in-memory inventory of every non-archived markdown file with its path, frontmatter fields, and last-updated date (from `updated:` frontmatter or inline `**Last updated:**` text).

## Step 2 — Stale document detection

From the inventory, flag any file where:
- `status` is `active`, `in-progress`, `draft`, or similar non-terminal value, AND
- The `updated:` date (or `**Last updated:**` inline date) is older than the stale threshold, OR no date is present at all.

Group flagged files by their `project` frontmatter value (use "Uncategorized" if missing). Sort groups by stalest-first.

## Step 3 — Status drift between trackers and weeklies

Find all files with `type: tracker` in their YAML frontmatter (any directory depth). For each tracker:
1. Locate the nearest sibling or child directory that contains weekly documents (look for directories named `weekly/`, `weeklies/`, or files matching a weekly naming pattern like `Week-NN.md` or `YYYY-WNN.md`).
2. Identify the most recent weekly document by filename or date.
3. Parse status indicators in both the tracker and that weekly: `[x]` (done), `[~]` (in-progress), `[ ]` (not started).
4. Flag any item that appears in both files but with conflicting status — e.g., marked `[~]` in the tracker but `[x]` in the weekly, or vice versa.

## Step 4 — Weekly log continuity

For each set of weekly documents found in Step 3 (and any other sequential weekly series discovered during inventory):
- Check for gaps in the sequence (e.g., Week-03 exists, Week-05 exists, but Week-04 is missing).
- In the previous weekly, find items marked `[ ]` (incomplete). Check whether those items appear anywhere in the latest weekly. Flag items that were left incomplete and then dropped without explanation.

## Step 5 — Broken wiki-links

Scan every non-archived markdown file for `[[wiki-links]]`. For each link:
1. Try to resolve the target as a filename match anywhere in the repository (case-insensitive, with or without `.md` extension).
2. Try to resolve it as a relative path from the linking file's directory.
3. If neither resolves to an existing file, flag it as broken. Record the source file and line number.

## Step 6 — Report

Output a single prioritized report in markdown. Include only sections that have findings — omit empty sections entirely.

### Sections (in this order):

1. **Stale Documents** — grouped by project, each entry showing file path, last-updated date, and days since update.
2. **Status Drift** — each entry showing the tracker file, the weekly file, the item text, and the conflicting statuses.
3. **Weekly Gaps** — missing weeks and dropped items, grouped by weekly series.
4. **Broken Links** — each entry showing source file, line number, and the unresolved `[[target]]`.

Format every flagged item with a checkbox (`- [ ]`) so the list is actionable.

End the report with a summary line:

> Scanned N files. Flagged N items for review.

**Reminder: this is a read-only audit. Make absolutely no changes to any files.**
