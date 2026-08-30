---
name: verify-this
description: "Prove or disprove a specific claim about the notebook with fresh evidence — falsifiable restatement, baseline, treatment, then VERIFIED / NOT VERIFIED / INCONCLUSIVE."
allowed-tools: Read Bash Grep Glob
---

`$ARGUMENTS`

Verification is not a recap. It proves or disproves one specific claim with evidence someone else could reproduce.

Use it when the user says "verify this", "did that actually work", "is the notebook clean now", or "show me the evidence" — and after any change to a command, a template, or a convention, where the thing you changed is the thing that reads the notebook.

Yacho has no test suite and no build. That is not a reason to skip verification; it changes what the evidence looks like. Here the evidence is a shell command over markdown that returns a count, a list, or nothing — run before the change and after it.

Do not use it on a vague claim like "the notebook is better organized". Ask for a countable claim first.

The argument is the claim to verify. If empty, ask what claim to test.

---

## Step 1 — Restate the claim falsifiably

Write the claim with a condition, a metric, and a threshold. "The links are fixed" is not a claim. "Zero unresolved `[[wiki-links]]` across `examples/`, down from 4" is.

State it back to the user before you spend time on it. If they meant something else, this is where it gets caught.

---

## Step 2 — Pick the smallest surface that could disprove it

Reach for the cheapest thing that can fail loudly. Yacho's real surfaces, in rough order of how often they apply:

**Frontmatter validity.** The audit commands key off `type`, `status`, `updated`, and `project`. A doc missing one is invisible to `/notebook-sync`, which looks like "no findings" rather than an error.

```bash
# Active docs with no updated: date — the staleness check cannot see these
for f in $(git ls-files '*.md' | grep -v '^templates/'); do
  head -12 "$f" | grep -q '^status: *active' && ! head -12 "$f" | grep -q '^updated:' && echo "$f"
done
```

**Wiki-link resolution.** `/notebook-sync` step 5 reports these; run the same resolution yourself to get a hard count.

```bash
grep -rn --include='*.md' -o '\[\[[^]]*\]\]' . | while IFS= read -r hit; do
  src="${hit%%:*}"; rest="${hit#*:}"; line="${rest%%:*}"
  target=$(printf '%s' "$hit" | sed 's/.*\[\[//; s/\]\].*//; s/|.*//')
  base=$(basename "$target"); dir=$(dirname "$src")
  [ -e "$dir/$target" ] || [ -e "$dir/$target.md" ] && continue
  find . -iname "$base.md" -o -iname "$base" | grep -q . && continue
  echo "$src:$line -> [[$target]]"
done
```

Known-clean baseline: `examples/` resolves fully. The only unresolved hits in a healthy checkout are the placeholder links inside `.claude/commands/*.md` and `CLAUDE.md` (`[[wiki-links]]`, `[[memory-name]]`, `[[path/to/file]]`) — those are illustrations, not links. Any hit under `examples/`, `weekly/`, `reference/`, `issues/`, or `runbooks/` is real.

**Status indicators.** `/repo-progress` parses exactly four symbols. Anything else is silently uncounted.

```bash
grep -rho '^\s*- \[.\]' --include='*.md' . | sort | uniq -c   # anything not [ ] [~] [x] [-] is a bug
```

**A command's own output.** For a change to a command, the command is the surface. Run it and read the report — `/notebook-sync` for the audit path, `/repo-progress <file>` for the gauge, `/memory-doctor` for the memory scan. Compare the report before and after, not your belief about what changed.

**The examples as fixtures.** `examples/student/` and `examples/multi-project/` are filled-in notebooks that ship with the repo. They are the closest thing yacho has to a test suite: run a changed command against one and check the report is still right. A command that only works on the maintainer's own notebook is broken for everyone who clones this.

**The gitignore boundary.** `scratch/` is ignored, and `.claude/memory/*.md` is ignored except `MEMORY.md`. If the claim is "this writes somewhere safe", prove it:

```bash
git check-ignore -v scratch/foo.md .claude/memory/user_role.md
git status --short          # nothing unexpected staged or untracked
```

**Rendered markdown.** GitHub renders `README.md` for every visitor. There is no linter — if the claim is about a table or a code fence rendering correctly, say you checked it by eye, and say that is rung 2, not rung 4.

---

## Step 3 — Capture a baseline

Run the check against the old state first, with the same command you will use afterward. Get "before" from `git stash`, the merge base, or a copy of the file — whatever honestly represents the state you are claiming to have improved.

A verification with no baseline is `INCONCLUSIVE`, not `VERIFIED`. Say so rather than skipping it.

---

## Step 4 — Capture the treatment

Same command, same files, changed state. Change one thing. If the baseline ran over `examples/` and the treatment ran over the whole repo, the comparison is confounded and the verdict is `INCONCLUSIVE`.

---

## Step 5 — Compare raw artifacts

Compare the actual output — counts, file lists, the report text — not your summary of it.

Write artifacts under `scratch/verify/<claim-slug>/` (gitignored):

```text
scratch/verify/<claim-slug>/
├── claim.md
├── baseline/
├── treatment/
└── verdict.md
```

Keep personal notebook content out of anything you paste into a public PR. A yacho notebook holds someone's real priorities, employer, and health notes — quote counts and paths, not the contents of a weekly doc.

---

## Step 6 — Return exactly one verdict

- **VERIFIED** — baseline and treatment differ in the predicted direction, by the claimed threshold, with no obvious confound.
- **NOT VERIFIED** — the behaviour is unchanged, moved the wrong way, or missed the threshold.
- **INCONCLUSIVE** — no valid baseline, a check that could not run, or a difference between the two runs that invalidates the comparison.

Use this shape:

```text
VERIFIED | NOT VERIFIED | INCONCLUSIVE
Claim: <the falsifiable restatement from step 1>

Evidence:
<metric or artifact>: baseline=<...>, treatment=<...>, delta=<...>, threshold=<...>
<command that produced it>

Reasoning:
<one tight paragraph naming the evidence and any confounds>
```

Do not soften a negative result. A clear `NOT VERIFIED` is the useful outcome — it stops a broken change from shipping. `INCONCLUSIVE` is honest and is not a failure; guessing in either direction is.

**Reminder: read-only. This command runs checks and reports. It does not fix what it finds — that is a separate pass.**
