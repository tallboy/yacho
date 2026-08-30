---
name: yacho-mode-convention-change
description: "Yacho playbook for changing a shared rule — frontmatter, status symbols, links, templates, layout. Find every consumer, migrate the fixtures, keep the docs in sync, PR. Routed to by /yacho-mode."
---

# Playbook — Convention change

Anything that changes a shared rule: a frontmatter field or `type` value, a status symbol, the wiki-link or back-link format, a template's shape, the directory layout.

This is the riskiest kind of change in the repo and the one that looks the safest. The conventions are an unenforced contract between the templates that write documents and the commands that read them. Break half of it and nothing fails — the audit just stops finding things and reports success.

It is also close to a one-way door. Yacho is a public template repo. Every clone out there already has documents written in the old form, and they will not be migrated. Prefer additive changes; when you must break something, say in the PR what an existing notebook has to do about it.

Copy these steps into the todo list verbatim. A step you skip stays in the list as `skip: <reason>`.

1. **Write down the rule as it is today, and the rule as you want it.** Two lines, before anything else. Include the exact strings — `status: active`, `[~]`, `**Back to:** [[parent]]`. If you cannot state the current rule precisely, you do not yet know what you are changing, and step 2 will be guesswork.

2. **Find every consumer, and count them.** Grep for the exact string across the whole repo, not just where you expect it. The rule is normally written down in more places than anyone remembers: the templates that emit it, the commands that parse it, the tables in `README.md` and `CLAUDE.md` that document it, and both fixture notebooks that demonstrate it. Write the count down — it is the checklist for step 4 and the number you re-check at step 7.

   ```bash
   grep -rn '<the exact string>' --include='*.md' .
   ```

3. **Decide additive or breaking, and say which.** Adding a new `type` value is additive: old notebooks keep working. Renaming a field, dropping a status symbol, or changing what a symbol means is breaking, and every existing notebook silently falls out of the audit. If it is breaking, justify it against the alternative of adding alongside and deprecating in prose — and if you go ahead, the PR body has to tell users what to do.

4. **Change every consumer in one pass.** Templates, commands, `README.md` (both the table and any prose), `CLAUDE.md`, and both fixtures. `CLAUDE.md` is what the AI reads at session start and `README.md` is what the human reads, so the two tables have to agree with each other and with reality. A convention that lands in the templates but not in `CLAUDE.md` will not get written; one that lands in `CLAUDE.md` but not in the commands will get written and never read.

5. **Migrate both fixtures and check they still demonstrate the rule.** `examples/student/` and `examples/multi-project/` are documentation as much as test data. After the change they should read as though the new convention had always been there. If a fixture now looks contrived, the convention is probably wrong.

6. **Run every command that touches the rule, against both fixtures.** `/notebook-sync` for frontmatter, links, and status drift; `/repo-progress` for anything about checkboxes; `/memory-doctor` for anything about memory files. Read the reports and check the numbers by hand. This is the step that catches a parsing rule you updated in the docs but not in the command.

7. **Re-run the grep from step 2 and reconcile the count.** Every hit is either updated, deliberately left as a placeholder or historical record, or a miss you just found. Say which is which. A leftover hit in a command is a live bug; a leftover hit in an `issues/` entry is history and stays.

8. **Run `/blast-radius` on the diff.** This playbook exists because convention changes reach further than they look, and the invariant checklist in that command is written for exactly this case. Get the one fact the change is safe because of down to rung 4 or 5.

9. **Run the checks.** The fixture runs from step 6, the grep reconciliation from step 7, the link resolver if anything moved, and the status-symbol census if checkboxes were involved. Report what each printed.

10. **Open the PR and stop.** Branch off fresh `origin/main` with a descriptive name, never push to `main`. Body uses the headings from `/yacho-mode`, and for a breaking change `## Blast Radius` must say plainly what an existing notebook will experience and what its owner should do. `## Verification` carries the before-and-after counts and the fixture reports. Post the URL with a short summary and stop. The user merges.

**Reply:** the old rule and the new one, the consumer count before and after, whether it is additive or breaking, what an existing notebook will experience, and the fixture reports. Name any skipped step and why.
