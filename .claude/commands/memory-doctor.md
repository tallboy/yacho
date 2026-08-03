---
name: memory-doctor
description: "Detect and correct poisoned memory entries — stale claims that something is broken/unavailable/true that has since changed. Verifies against current state before correcting; never deletes, only supersedes with a CORRECTION prefix."
allowed-tools: Read Glob Grep Edit Bash
---

`$ARGUMENTS`

Optional argument: a keyword or topic to scope the scan (e.g. `/memory-doctor servicenow`). Without one, scan every memory file.

Memory reflects past state. Most of the time that's fine — but a memory written after a bug, an outage, or an org change can outlive the thing it describes. A "poisoned" entry is one that's still confidently telling the AI something that's no longer true: a workaround for a bug that's since been fixed, a "tool X doesn't support Y" claim that's now wrong, a headcount/org fact that's stale. Left uncorrected, these compound — the AI keeps avoiding a fixed path, or keeps repeating an outdated fact, and the user has to correct it over and over.

This command finds those entries, checks whether they're still true, and fixes the ones it can verify. It never deletes anything — corrections supersede via a visible prefix, so the original claim and its correction are both on the record.

---

## Step 1 — Load Memory

Read `.claude/memory/MEMORY.md` and every file it indexes. If `$ARGUMENTS` was given, only load files whose filename, description, or content matches the keyword.

## Step 2 — Anti-Pattern Scan

Flag any memory whose body contains language shaped like an absolute, testable claim:

- **Broken/unavailable claims**: "doesn't work", "is broken", "not supported", "always fails", "no longer works", "not available", "deprecated"
- **Workaround claims**: "must use X instead because Y fails", "workaround for", "avoid X, use Y"
- **Access/permission claims**: "cannot edit", "read-only", "access denied", "requires approval"
- **Time-sensitive facts** (not necessarily wrong, but decay fast): org structure, headcount, who reports to whom, current role/title, "currently in progress" project state

For each flagged memory, note: the file, the specific claim, and whether it looks independently testable right now (references a file path, command, tool name, URL, or other thing you could check directly) versus not testable in this session (a fact about people/org state that requires the user to confirm).

## Step 3 — Conflict Scan

Compare feedback and project memories against each other. Flag any pair where one directly contradicts another (e.g., two rules that can't both apply, or a project memory superseded by a more recent one that never got cross-referenced). Prefer the more recently dated/modified file as the likely-correct one, but still flag both for review rather than assuming.

## Step 4 — Verify Testable Claims

For each **testable** candidate from Step 2, actually check it:
- Referenced file/path → does it still exist? (`Glob`/`Read`)
- Referenced command/script → does it still behave as described? (`Bash`, read-only checks only — do not run anything destructive or stateful)
- Referenced tool/connector/skill → is it still named that, still present?
- Referenced pattern in code/config → `Grep` for it

Classify each candidate:
- **CONFIRMED STALE** — tested directly, the claim is now false
- **LIKELY STALE** — time-based heuristic (old date, org/people fact), not independently testable this session
- **CONFLICT** — contradicts another memory
- **STILL VALID** — tested and still holds, or no evidence of staleness

## Step 5 — Report

```
# Memory Doctor — [today's date]

## Confirmed Stale (verified — will propose a correction)
- [[memory-name]] — claimed: "..." — tested: [what you checked] — now: [actual state]

## Likely Stale (needs your confirmation — not independently testable)
- [[memory-name]] — claimed: "..." — why it looks dated: [reason]

## Conflicts
- [[memory-a]] vs [[memory-b]] — "..." contradicts "..." — [[memory-b]] is newer, likely correct

## Still Valid
[one-line count only, e.g. "14 memories checked, no issues found" — don't enumerate the boring ones]
```

## Step 6 — Apply Corrections (only on confirmation)

Do NOT edit any memory file yet. Present the report first and ask which corrections to apply — default suggestion is "apply all Confirmed Stale, leave Likely Stale and Conflicts for manual review" but let the user decide.

For each correction the user approves:
1. Open the memory file and prepend a line right after the frontmatter's closing `---`:
   ```
   **CORRECTION (YYYY-MM-DD):** [what's actually true now]. Original claim below is kept for history.
   ```
2. Leave the original body intact underneath — do not delete or rewrite it.
3. If the file's `description:` frontmatter field states the stale claim, update the description too (descriptions are what future sessions match against, so a stale one keeps surfacing the wrong context even after the body is corrected).
4. If MEMORY.md's index line for this file quotes the stale claim, update that one-line summary too.

Never delete a memory file as part of this command. If a memory is fully obsolete (not just wrong in one detail), flag it for the user to decide on deletion themselves — that's outside this command's scope.

## Step 7 — Verify

After applying corrections, re-read the edited files to confirm the CORRECTION line is present and the original content is preserved.

**Reminder: read-only through Step 5. Nothing gets written until the user has seen the report and confirmed which corrections to apply.**
