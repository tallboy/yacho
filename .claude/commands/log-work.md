---
name: log-work
description: "Keep an append-only TSV decision trail for long or unattended work — one row per decision (what, why, evidence, result) under scratch/decisions/."
allowed-tools: Read Bash Glob
---

`$ARGUMENTS`

Leave a trail someone can follow. For work that runs long, runs unattended, or gets reviewed after the fact, a decision log lets a reader reconstruct what was decided, why, and on what evidence — without rerunning the work or reading the whole transcript.

This is not a daily log and it is not a work tracker. A daily log records what happened to you; a work tracker lists steps still to do. A decision log records forks you took and the evidence you took them on, while you are in the middle of taking them.

One canonical log per effort, so a future session can find it.

The argument is the decision to record, in plain words. If empty, either start a new log for the current effort or show the existing one and ask what to append.

---

## Step 1 — Pick the log file

Logs live under `scratch/decisions/`. `scratch/` is gitignored, so a log never lands in a commit unless you deliberately copy it somewhere else.

- One effort at a time: `scratch/decisions/<task-slug>.tsv`
- Tied to a document you are reworking: `scratch/decisions/<doc-name>.tsv`
- Tied to a GitHub issue: `scratch/decisions/issue-<N>.tsv`

Check for an existing log before creating a new one:

```bash
ls scratch/decisions/ 2>/dev/null
```

Reuse the matching log. Do not start a second file for the same effort.

---

## Step 2 — Know the columns

A single TSV file, one row per decision. TSV because GitHub renders it as a sortable table, `column -s$'\t' -t` and spreadsheets read it, and a row appends with one command. Cells stay on one line. Evidence is a pointer, not prose.

| Column | What goes in it |
|--------|-----------------|
| **ts** | ISO8601 timestamp. The timeline axis. |
| **phase** | The phase or workstream — `audit`, `templates`, `commands`, `memory`, `write-up`. |
| **decision** | What was chosen or done, one line. |
| **why** | The reason in plain words. If a principle drove it, say it plainly, not as a jargon tag. |
| **evidence** | A link or path that proves it: a commit SHA, a PR number, `file:line`, a command you ran, an artifact path. Never a paragraph. |
| **result** | The outcome or state: `applied`, `reverted`, `INCONCLUSIVE`, `open`. |

The header row lives at `.claude/references/decision-log-template.tsv`. An illustration of the shape — do not copy these rows into a real log:

```
ts	phase	decision	why	evidence	result
2026-08-26T09:02:00Z	audit	counted the docs with no updated: field before fixing any	wanted the size before starting	grep -L 'updated:' weekly/*.md	11 of 14 weeklies
2026-08-26T09:40:00Z	templates	added the new type to the frontmatter table in README and CLAUDE.md	notebook-sync skips a type it does not know about	CLAUDE.md:31	both tables agree
2026-08-26T11:15:00Z	commands	dropped the auto-fix branch from the audit for now	notebook-sync is documented read-only and the examples depend on that	.claude/commands/notebook-sync.md:12	deferred, noted in the PR
```

---

## Step 3 — Append a row

Use the helper so rows stay well-formed:

```bash
.claude/scripts/log.sh scratch/decisions/<slug>.tsv <phase> <decision> <why> <evidence> <result>
```

It stamps `ts`, writes the header on first use, strips stray tabs and newlines so cells stay single-line, and prefixes any cell starting with `=`, `+`, `-`, or `@` with a single quote — so a reader who opens the log in a spreadsheet does not trigger formula execution on text that came from a PR title, a filename, or generated output.

A bare `printf` appending a row works too, but mind those same bytes.

Write each row the way you would tell a colleague what you did. Plain words, concrete actions, no AI voice — run the text through `/unslop` in your head before it lands.

---

## Step 4 — Know what earns a row

Log decision points and checkpoints, not every action:

- A fork chosen between two real options
- A unit finished, with how you checked it
- A pivot or revert, with what triggered it
- A blocker surfaced
- A convention you decided to bend, and why

Skip the trivial and self-evident. For a loop or a batch pass over many files, one row per iteration.

Rules:

- One row is one decision. If it does not fit on one line, the decision is not crisp yet.
- Append-only. A wrong call gets a new row that supersedes it. Never edit or delete history. This matches the notebook's own rule about logs and records — they are historical artifacts, not drafts.
- Prefer evidence a reader can re-run (a `grep` you actually ran, a command, a `file:line`) over a hand-made one-off.

---

## Step 5 — Audit the log before handing back

At the end of the run, check the log told the truth. Walk it against what actually happened:

- Every row maps to a real action. Cut invented or aspirational entries.
- Each row's evidence resolves and shows what the row claims.
- A fork, pivot, or abandoned approach that shaped the work but is not logged is a gap. Add it.
- Drop padding. If nobody would read a row, it has not earned its place.

Fix the log, not the story. If the work diverged from what a row claims, the row is wrong.

---

## Step 6 — Report

Render the log and tell the user where it lives:

```bash
column -s$'\t' -t scratch/decisions/<slug>.tsv
```

The log stays local by default — `scratch/` is gitignored and most work does not need a committed trail. Copy it somewhere durable only when the effort was big enough that a reader needs the trail to trust the result: into a PR body for a wide change, or into an `issues/` catalog entry when the decisions were the troubleshooting.

**Reminder: this command only appends. It never edits or deletes an existing row.**
