---
name: yacho-mode-investigation
description: "Yacho playbook for read-only questions — gather evidence across the commands, templates, fixtures, git history, and GitHub, then write findings. No file change. Routed to by /yacho-mode."
---

# Playbook — Investigation

A read-only question whose deliverable is an answer, not a diff: how does X work, why is it built this way, is convention Y actually used by anything, should we do A or B.

The deliverable is a written finding with its evidence attached. Not an edit.

The discipline is evidence before conclusions. Form the answer from what you observed, in that order — gather, then conclude. The failure mode is deciding what the answer is in the first two minutes and then collecting the citations that agree with it. If your first hypothesis survives, it should survive an attempt to kill it, not an absence of one.

Copy these steps into the todo list verbatim. A step you skip stays in the list as `skip: <reason>`.

1. **Restate the question so it can be answered wrong.** Write it in a form that has a checkable answer, and name what would count as evidence for and against. "Is the frontmatter convention actually used?" becomes "which commands filter on `type`, `status`, `updated`, or `project`, and which fields does nothing read?" If the restatement changes the question, say so — the user may have meant the other one.

2. **Say up front that this pass produces no file change.** Investigation ends in a write-up. If the answer turns out to be "and therefore we should change X", that change is a separate pass under **Command change** or **Convention change**, started after the finding is reported. Don't slide from reading into editing.

3. **Gather evidence from the sources that apply. Name which ones you skipped.**
   - **The commands.** `.claude/commands/*.md` read end to end, not grepped for the word in the question. These are the only things in the repo with behaviour, so most questions end here. Cite `file:line`.
   - **The templates.** `templates/` defines what a document looks like when it is created. A mismatch between a template and the command that reads it is itself a finding.
   - **The fixtures.** `examples/student/` and `examples/multi-project/` show the conventions as actually practised, which is not always what the docs claim. Running a command against a fixture is evidence; reasoning about what it would print is not.
   - **The docs.** `README.md` and `CLAUDE.md`. Treat these as intent and check whether the commands still match — divergence between the two is a finding worth reporting on its own.
   - **Git history.** `git log -S '<exact string>'` to find when a convention arrived or changed, and `git log -p` on the file for the reasoning. `git log --oneline` around that date shows what shipped alongside it. Yacho's history is short enough to read in full if you need to.
   - **GitHub.** `gh issue list --state all` and `gh pr list --state all`. The repo takes outside contributions, so a PR body may be the only place a decision was written down.
   - **The user's own notebook**, if the question is about real use rather than the framework. Ask before reading `weekly/`, `reference/`, or `.claude/memory/` — those hold personal content, and nothing from them goes into a public write-up.

4. **Try to falsify the leading answer.** Once one explanation is ahead, spend a pass attacking it. Find the command that would contradict it, the commit that would predate it, the fixture that would disagree. If it survives, the answer is stronger and you can say why. If it doesn't, you just avoided shipping a confident wrong answer. For a decision between alternatives, do this for both sides and build a tradeoffs table.

5. **Grade your own confidence, honestly.** Every claim is one of: **verified** (you observed it — cite the file, the command you ran, the output), **inferred** (it follows from what you observed, and you say from what), or **unknown** (you couldn't reach it — how a stranger's notebook is actually laid out, whether a convention is followed outside this repo). Unknown is a real answer and more useful than a confident guess. Never cite a file you didn't actually read this session.

6. **Write the finding.** Structure it as: **Answer** (the short version, first, in a couple of sentences), **How it works** (the mechanism, with `file:line` citations), **Evidence** (what you ran and what it returned), **Gotchas** (the surprising parts, and any divergence between the docs and the commands), **Open** (what stayed unknown and what it would take to close it). For a decision question, replace the middle with a tradeoffs table and a recommendation you actually hold. If the premise of the question is wrong, say that first and explain why — agreement is not the default.

7. **Land the finding somewhere it survives the session.** Default is the reply. Also do whichever apply: `gh issue comment <N>` if the question came from an issue; an `issues/` catalog entry if the investigation was a diagnosis worth keeping, following `templates/issue-catalog.md` with its root cause and prevention fields; a `reference/` sheet if what you learned is stable and you will look it up again; a new GitHub issue if a follow-up is big enough. A finding that only exists in a chat transcript gets re-discovered from scratch in three months.

8. **Checks and PR: normally neither, and say so.** An investigation with no diff runs no checks and opens no PR — record it as `skip: read-only investigation, no diff`. One exception: if you commit the write-up, it follows the full PR conventions in `/yacho-mode` — branch off fresh `origin/main`, never push to `main`, the five headings, post the URL and stop. And if the investigation created anything under `scratch/`, confirm `git status --short` is clean before you finish.

**Reply:** the finding itself, written per step 6, with every claim marked verified, inferred, or unknown. Name any skipped source and why. If the answer implies work, name the follow-up and which playbook it routes to — don't start it in this pass.
