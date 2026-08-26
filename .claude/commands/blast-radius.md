---
name: blast-radius
description: "Find what a change to a command, template, or convention could break somewhere else before it ships — beyond the diff — and prove the one fact it's safe because of."
allowed-tools: Read Bash Grep Glob
---

`$ARGUMENTS`

Find what a change breaks somewhere else, before it ships. Use it for "what could this break", for a diff that looks too small for what it claims, and before merging anything that touches frontmatter, status indicators, the templates, or a command that other commands depend on.

Yacho looks like a pile of markdown, so it looks like nothing can break. That is the trap. The conventions are a contract between the templates that produce documents and the commands that read them, and nothing enforces that contract — no schema, no linter, no CI. A convention change that only lands in half the places does not fail. It just quietly stops finding things, and `/notebook-sync` reports "no findings" when it should have reported eleven.

The second trap is that this is a public template repo. Every change ships to everyone who clones yacho, into notebooks you will never see.

The argument is a branch, a commit range, or a file path. If empty, use the working tree diff against `origin/main`.

---

## Don't trust your own writeup

A blast-radius writeup that sounds right is worthless. It reads as convincing whether or not it is true. So do not hand back the writeup. Find the one or two facts the whole thing depends on and prove them by running something.

### How sure are you — the evidence ladder

For each fact the change's safety depends on, get it as far down this list as is cheap, and say where it stopped.

1. **You said so.** Worthless on its own.
2. **You pointed at the line.** A real `file:line` in the command or template that consumes the thing you changed.
3. **You showed the bad case cannot happen.** You walked the failure step by step and it does not reach.
4. **You ran a check.** A `grep` or `find` over the repo that would list the breakage if it existed, and returned what you expected.
5. **You ran the command against a fixture.** `/notebook-sync` or `/repo-progress` driven over `examples/student/` or `examples/multi-project/`, and you read the report.

Rung 5 is cheap here — the fixtures are committed and the commands are read-only. There is little excuse for stopping at rung 3.

---

## Steps

### 1 — Read the change

```bash
git diff origin/main...HEAD --stat
git diff origin/main...HEAD
```

What changed, and what a document or a command now does differently — including the part the diff does not spell out.

### 2 — Find the one fact it's safe because of

Most changes that look scary are safe because of a single fact ("nothing reads that field except the command I just edited"). Find that fact. If it holds, most of the scary cases die at once. Spend your time here, not on a long list of maybes.

### 3 — Look where grep stops

Read the commands that consume what you changed. Then follow what a symbol search misses:

- A frontmatter field, and every command that filters on it
- A convention documented in `README.md`, `CLAUDE.md`, and demonstrated in `examples/` — three copies that drift apart
- A template's shape, and the command that fills it in (`/setup` writes from `templates/`)
- A command's report format, and another command that suggests piping into it (`/repo-progress` ends by pointing at `/compose`)

### 4 — Run the yacho invariant checklist

These are the cross-cutting rules a local-looking change breaks silently. Check each against the diff and say which ones the change touches.

- **Frontmatter is the query interface.** `type`, `status`, `updated`, `project` are what the audit commands filter on. `/notebook-sync` builds its inventory from them (steps 1–4), finds trackers by `type: tracker` rather than by filename (that was a real fix — commit `779541c`), and skips anything `status: archived`. `/repo-progress` selects Mode A on `type: tracker`. Adding a new `type` value means adding it to the table in `CLAUDE.md` **and** the one in `README.md`, or the AI will never write it. Renaming or dropping a field silently empties an audit — the report says "no findings", which reads exactly like success.

- **Four status symbols, and only four.** `[ ]`, `[~]`, `[x]`, `[-]`. `/repo-progress` counts all four and deliberately excludes `[-]` from the completion percentage, because cancelled is not incomplete. `/notebook-sync` step 3 compares `[~]` in a tracker against the weekly. A fifth symbol, or a capital `[X]` in a command that only matches lowercase, is not an error — it is an item that stops being counted. Check the parsing rule and the documented set together.

- **Wiki-links and back-links are load-bearing.** `[[target]]` resolution is checked by `/notebook-sync` step 5, and every document is supposed to carry a `**Back to:** [[parent]]` link. Moving or renaming a file under `examples/` breaks inbound links from its siblings. Placeholder links inside `.claude/commands/*.md` and `CLAUDE.md` (`[[wiki-links]]`, `[[memory-name]]`, `[[path/to/file]]`) are illustrations and are expected to be unresolvable — do not "fix" those, and do not let them mask a real broken link elsewhere.

- **A command exists in up to four places.** The command file, the Directory Structure tree in `README.md`, the Commands section in `README.md`, and the Commands list in `CLAUDE.md`. `CLAUDE.md` is the one the AI reads at session start, so a command missing from it effectively does not exist. Templates have the same problem: `templates/`, the table in `README.md`, and the Artifact Types table in `CLAUDE.md`. Adding or renaming means updating every copy in the same change.

- **The gitignore boundary separates the framework from the user's life.** `scratch/` is ignored. `.claude/memory/*.md` is ignored **except** `MEMORY.md`, which is committed as an empty index with commented-out examples. That asymmetry is deliberate: individual memories are personal and stay local, the index template ships. A command that writes real memory entries into `MEMORY.md` commits somebody's role, employer, and deadlines into a public repository. Verify with `git check-ignore -v <path>` and `git status --short`, not by reading the gitignore and assuming.

- **Read-only commands are read-only, and say so in their own text.** `/notebook-sync` and `/repo-progress` both end with a reminder that they change nothing; `/memory-doctor` is read-only through step 5 and edits only after the user confirms. Users rely on being able to run these without thinking. Adding a write to one of them breaks a promise printed in the command itself — if a change needs to write, it needs a new command or an explicit confirmation gate, and the reminder line has to change with it.

- **It ships to strangers, and their notebook is empty.** A fresh clone has no `priority-tracker.md`, no memories, and empty `weekly/`, `reference/`, `issues/`, `runbooks/` directories holding only `.gitkeep`. Any command that assumes a file exists fails on the first run a new user ever does. Absolute paths, the maintainer's own project names, and anything personal must not appear in a committed file. A search for absolute home paths should stay empty — `grep -rn '/Us[e]rs/' --include='*.md' .`, where the bracket keeps this line from matching itself.

- **The examples are fixtures and documentation at once.** `examples/student/` and `examples/multi-project/` demonstrate every convention. Change a convention without updating them and the repo now teaches the old one. They are also the only realistic input a command gets tested against.

### 5 — Be honest about each risk

Give each risk a real chance of happening and a real cost if it does. Keep the ones you confirmed; list the ones you checked and cleared separately. Cite a real `file:line`. A search that finds nothing is still an answer. Never invent a consumer.

### 6 — Prove the one fact

Run the check that would fail if you are wrong, and paste what happened. Usually a grep over the repo, or one of the read-only commands driven against a fixture:

```bash
grep -rn 'type: tracker' --include='*.md' .          # who actually depends on the field
grep -rho '^\s*- \[.\]' --include='*.md' . | sort | uniq -c   # every status symbol in use
```

If you cannot prove it cheaply, mark it unproven. Do not round up.

---

## What to hand back

- **What it does.** What changed, including the part that is not obvious from the diff.
- **The one fact it's safe because of.** State it, say which rung you got it to, and show the proof. If you could not prove it, write unproven.
- **Invariants touched.** Which of the checks above this change is near, and what you found for each.
- **Risks.** Only the real ones. Each names how it breaks, the `file:line`, how likely and how bad, and how to check.
- **Cleared.** What you checked and why it is fine.
- **Before you merge.** The cheapest check that catches the real problem.

Write it through `/unslop`, cite real files, and keep personal notebook content out of anything that goes into a public PR.

**Reminder: read-only. This command investigates and reports. Fixing what it finds is a separate pass.**
