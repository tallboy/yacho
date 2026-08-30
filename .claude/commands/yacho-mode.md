---
name: yacho-mode
description: "Route a task to the right yacho playbook, then work the playbook's steps as your todo list. Covers command changes, convention changes, and read-only investigations."
allowed-tools: Read Edit Write Bash Grep Glob TodoWrite
---

`$ARGUMENTS`

Yacho has good leaf commands (`/setup`, `/notebook-sync`, `/memory-doctor`, `/repo-progress`, `/compose`) and good checks (`/verify-this`, `/blast-radius`). What it has not had is the layer above them: which sequence of moves a command change deserves versus a convention change versus a question.

`/yacho-mode` is that layer. It matches the request to a playbook and turns that playbook into the session's todo list.

This is for work **on the yacho framework itself** — editing commands, templates, conventions, docs. It is not for using your notebook. Writing this week's plan or logging an issue needs no playbook; just write the document.

Invoke it per task. It is not a mode you enter and stay in — a new task means a new `/yacho-mode` call, and a casual question needs no call at all.

If the argument is empty, ask the user what they're working on before matching.

---

## Step 1 — Match the request to a playbook

Read the table top to bottom and take the first row that fits.

| Playbook | Match when the request is | File |
|---|---|---|
| **Convention change** | Anything that changes a shared rule: a frontmatter field, a `type` value, a status symbol, the wiki-link or back-link format, a template's shape, the directory layout. Wins over Command change whenever a command edit drags a convention along. | `yacho-mode/playbooks/convention-change.md` |
| **Command change** | New or changed behaviour in a `.claude/commands/*.md` file — a new command, a new step, a changed report format, a bug in how a command parses the notebook. | `yacho-mode/playbooks/command-change.md` |
| **Investigation** | A read-only question whose deliverable is an answer, not a diff: how does X work, why is it built this way, is convention Y actually used, should we do A or B. | `yacho-mode/playbooks/investigation.md` |

Disambiguation, in order:

- **Conventions beat commands.** A command change that also adds a frontmatter field runs **Convention change** for the convention and **Command change** for the rest. Two playbooks, one after the other, both in the todo list — not a blend.
- **"The command is broken" without a reproducible symptom is an Investigation**, not a Command change. Find the symptom on a real notebook first, then re-route.
- **An Investigation that concludes "so we should change X" stops there.** Report the finding, then start the matching change as its own pass. Don't quietly slide from reading into editing.
- A pure prose edit to `README.md` or a typo fix needs no playbook. Make the change, run `/unslop` on it if it is more than a word, open the PR.

Say which playbook you matched and why, in one line, before you start.

---

## Step 2 — Copy the playbook's steps into the todo list verbatim

Open the matched file. Copy its numbered steps into the todo list **as written, before any task-specific todos, and before you start reasoning about the task**.

The failure this prevents: reading a playbook, feeling like you understood it, then writing a bespoke plan that quietly drops the steps you didn't feel like doing. The dropped step is always the same kind — the run against the fixture, the second place the convention is documented, the write-down.

Rules for the list:

- Verbatim. Don't paraphrase a step into something easier.
- Task-specific todos go **after** the playbook's steps, not interleaved into them.
- **A step you decide not to do stays in the list, rewritten as `skip: <reason>`.** For example, `4. Run against both fixtures — skip: change is a typo in a comment, no parsing affected`. A reason is a fact about this task, not a mood: "not needed here", "seems fine", and "small change" are not reasons.
- Silently deleting a step is not allowed. If you find yourself wanting to, that's the signal the step is load-bearing.
- Skipped steps stay visible in the final summary too, so the reviewer sees what you chose not to do.

---

## Step 3 — No playbook matches: design the checklist

Large or cross-cutting work — a restructure of the directory layout, a new template plus the command that writes it, anything the user walks away from and reviews later — gets a bespoke checklist. Design it before you touch anything.

Ground it on three things, written down before the first edit:

1. **A falsifiable done-predicate.** State done as something that can be checked and could come back false. "`/notebook-sync` run against `examples/multi-project/` reports the same findings as before the change, plus the two new stale-date hits" is a predicate. "The audit works better" is not.
2. **Scope, quantified.** Which files, how many places the convention is written down, and every blocker you already know about.
3. **The rigor level, and why.** A convention change is close to a one-way door — it ships to everyone who clones the repo, and their notebooks are already written in the old form. More checks, more evidence. A wording fix in one command is reversible: fewer.

Then decompose into units that each end in a check, order them riskiest-unknown-first, and add them to the todo list under the same rules as Step 2 — including `skip: <reason>`.

Present the framing before committing to a long run. If it turns out a playbook fits after all, use the playbook.

---

## The checks

Every playbook ends here. Yacho has no test suite and no build, so the checks are shell commands over markdown and the commands themselves run against the committed fixtures. Run the ones the diff actually touches, and say which ones you ran and what they printed.

| Check | How | Run it when |
|---|---|---|
| Fixture run | Drive the changed command over `examples/student/` and `examples/multi-project/`, read the report | Any change to a command's logic or report format |
| Empty-notebook run | Same command with no tracker and no memories present | Any command a brand-new user could run first |
| Link resolution | The wiki-link resolver in `/verify-this` step 2 | Any file move, rename, or new document |
| Frontmatter sweep | `grep` for the field across `examples/` and `templates/` | Any frontmatter change |
| Status symbols | `grep -rho '^\s*- \[.\]' --include='*.md' . \| sort \| uniq -c` | Any change to how checkboxes are parsed or written |
| Docs quartet | The command or template appears in its file, both `README.md` sections, and `CLAUDE.md` | Any added, renamed, or removed command or template |
| Ignore boundary | `git check-ignore -v <path>` and `git status --short` | Any change to where a command writes |

"Inconclusive" is not a pass. A check you meant to run and didn't is a check you have not run; say so rather than rounding it up to green.

Reach for `/verify-this` when a step says to prove something, and `/blast-radius` before merging anything that touches a convention.

---

## PR conventions

Yacho is a public template repo. Changes ship to everyone who clones it.

- **Branch.** `git fetch origin` first, then branch from fresh `origin/main` with a descriptive name (`feat/`, `fix/`, `docs/` + a short slug). Never commit or push to `main`.
- **Scope.** One concern per PR. Anything you find outside it goes in the PR body under what you did not do, or into a GitHub issue.
- **No personal content.** Never commit a real `priority-tracker.md`, a real weekly doc, a real memory file, or anything with a name, employer, or absolute home path in it. The fixtures under `examples/` are the only filled-in notebooks that belong in the repo.
- **PR body** uses these headings, in order, dropping any that would be empty:
  - `## Why` — the intent, and why this approach fits.
  - `## Scope` — facts from the diff. Real paths. Both sides of a rename.
  - `## Tradeoffs` — real choices only. Drop the heading when there are none.
  - `## Blast Radius` — what this touches and who feels it. Any convention change has one. Say why it's safe, or why it isn't.
  - `## Verification` — each check you ran, and what it printed. Outcomes, not command names.
- **Stop after the PR.** Post the URL with a short summary: what changed, how it was checked, what the risks are. Don't merge. Wait for the user.

---

## Reply

End every playbook with:

- Which playbook you matched.
- Its steps, with every `skip: <reason>` still visible.
- What you built or found.
- The checks you ran and their outcomes.
- The PR URL.
- What's still open, and any real risk. If you think the approach is wrong, say so — agreement is not the default.
