---
name: yacho-mode-command-change
description: "Yacho playbook for a new or changed slash command — read the neighbours, write it in house format, run it against the fixtures, wire it into the docs, PR. Routed to by /yacho-mode."
---

# Playbook — Command change

New or changed behaviour in a `.claude/commands/*.md` file: a new command, a new step, a changed report format, or a bug in how a command reads the notebook.

A command in this repo is a prompt, not code. Nothing type-checks it and nothing runs it in CI. The only way to know it works is to run it against a real notebook and read what it produced.

Copy these steps into the todo list verbatim. A step you skip stays in the list as `skip: <reason>`.

1. **Read two neighbouring commands before writing anything.** The house format is narrow and worth matching: YAML frontmatter with `name`, a quoted `description`, and `allowed-tools`; a bare `` `$ARGUMENTS` `` line opening the body; `## Step N — Title` headings separated by `---` rules; a fenced Report Format block near the end; and a bold `**Reminder:** ...` line for anything read-only. `/notebook-sync` and `/memory-doctor` are the best models for an audit-shaped command, `/setup` for an interactive one. Match what you find rather than inventing a new shape.

2. **Say what the command reads and what it writes, before you write it.** One line each. This is the decision a reviewer most needs to disagree with, and it determines everything else: a read-only command gets the reminder line and can be run without thought; a writing command needs a confirmation gate and has to respect the gitignore boundary. `/memory-doctor` is the reference for the middle case — read-only through step 5, edits only after the user picks. If the command writes into `.claude/memory/`, re-read the invariant in `/blast-radius` about `MEMORY.md` being the one committed file there.

3. **Write it so it works on a notebook you have never seen.** This repo is cloned by strangers. Never hardcode a path from your own machine, a project name, or an assumption that `priority-tracker.md` exists. Find documents by frontmatter `type`, not by filename — that distinction was already a bug once (`779541c`, `fix(notebook-sync): find trackers by frontmatter type instead of filename`). Say what the command does when it finds nothing, because on a fresh clone it will.

4. **Run it against both fixtures.** `examples/student/` and `examples/multi-project/` are committed filled-in notebooks and they are the closest thing yacho has to a test suite. Drive the command over each one and read the report. Check the numbers by hand against the files — a gauge that prints 65% is only right if you can count the checkboxes and get 65%. If the command changed a report format, put the old and new report side by side.

5. **Run it on an empty notebook.** No tracker, no memories, empty `weekly/`. This is the first thing a new user does after cloning, and it is the case that is never tested. The command should report that it found nothing, not error and not invent a finding. Skip only if the command cannot be reached without existing documents, and say why.

6. **Wire it into the docs, all four places.** A command lives in its own file, the Directory Structure tree in `README.md`, the Commands section in `README.md`, and the Commands list in `CLAUDE.md`. `CLAUDE.md` is what the AI reads at session start, so a command missing there effectively does not exist. For a renamed command, update both sides of the rename everywhere. Confirm with a grep for the command name across the repo — the count should match what you expect.

7. **Run `/unslop` on the command's own prose.** These files are read by a model and by the user, and they are the most-read prose in the repo. Pattern 27 is the one that matters: every step should tell the reader something to do or check, not how the command feels.

8. **Run the checks.** The fixture runs from steps 4 and 5 are the main ones. Add the link resolver if you moved or added a file, and `git status --short` plus `git check-ignore -v` if the command writes anywhere. Report what each printed, not just that you ran it.

9. **Open the PR and stop.** Branch off fresh `origin/main` with a descriptive name, never push to `main`. Body uses the headings from `/yacho-mode`: `## Why`, `## Scope`, `## Tradeoffs`, `## Blast Radius` (which commands or docs also had to change), `## Verification` (the fixture reports and what you checked in them). Paste the report the command produced — that is the evidence, and it is short enough to include. Post the URL with a short summary and stop. The user merges.

**Reply:** what the command does, what it reads and writes, the reports it produced on both fixtures and on an empty notebook, and the four doc locations you updated. Name any skipped step and why.
