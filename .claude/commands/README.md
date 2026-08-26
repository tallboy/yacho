# Commands

Every slash command in this notebook, what it is for, and which ones chain into which.

Two groups. **Notebook commands** are for using your notebook — planning, auditing, drafting. **Framework commands** are for working on yacho itself: editing commands, templates, and conventions. Most people only ever need the first group.

---

## Notebook commands

| Command | Does | Writes? |
|---|---|---|
| `/setup` | Guided 15-minute onboarding — brain dump, north star, first tracker, weekly, and reference sheet | Yes — creates your first documents and memories |
| `/notebook-sync` | Weekly review and audit — north star check, stale docs, status drift, weekly gaps, broken links | No |
| `/memory-doctor` | Finds memory entries that were true when written and no longer are, verifies them, corrects with a visible prefix | Only after you confirm |
| `/repo-progress` | Checkbox-completion gauge from a tracker, plus git/gh activity if pointed at a code repo | No |
| `/compose` | Drafts a message and writes it as clean HTML for pasting into Outlook or Teams | Yes — one file under `scratch/` |
| `/unslop` | Cuts AI tells from a piece of writing and puts a human voice back in | Yes — rewrites the file you name |

## Framework commands

| Command | Does | Writes? |
|---|---|---|
| `/yacho-mode` | Routes a task to the right playbook and turns it into the session's todo list | Delegates |
| `/log-work` | Append-only TSV decision trail under `scratch/decisions/` for long or unattended work | Yes — appends rows |
| `/verify-this` | Proves or disproves one specific claim about the notebook, then returns VERIFIED / NOT VERIFIED / INCONCLUSIVE | No |
| `/blast-radius` | Finds what a change to a command, template, or convention breaks somewhere else | No |

`/yacho-mode` routes to three playbooks under `yacho-mode/playbooks/`: **command-change**, **convention-change**, and **investigation**.

---

## How they chain

**The weekly loop.** This is the one to build a habit around.

```
/notebook-sync  →  fix what it flagged  →  /unslop on any doc you rewrote
                →  /repo-progress  →  /compose  →  paste into Teams
```

`/notebook-sync` finds the problems, you fix them, `/repo-progress` turns the result into a shareable gauge, and `/compose` formats it for wherever your status update goes. `/repo-progress` ends by pointing at `/compose` for exactly this reason.

**Starting out.**

```
/setup  →  (a week of real use)  →  /notebook-sync
```

**When memory goes stale.** Run this when the assistant keeps telling you something you know is no longer true.

```
/memory-doctor  →  review the report  →  confirm the corrections
```

**Changing the framework.** Everything starts at the router.

```
/yacho-mode <task>
   ├─ convention-change  →  /blast-radius  →  /verify-this  →  PR
   ├─ command-change     →  run against examples/  →  /verify-this  →  PR
   └─ investigation      →  write-up  →  issues/ or reference/ entry
```

`/log-work` runs alongside any of these when the work is long or unattended. `/unslop` runs on the prose before it lands.

---

## Conventions for writing a new command

Match what is already here:

- Frontmatter with `name`, a quoted `description`, and `allowed-tools`.
- A bare `` `$ARGUMENTS` `` line opening the body, then what the argument means.
- `## Step N — Title` headings separated by `---` rules.
- A fenced Report Format block when the command produces a report.
- A bold `**Reminder:** ...` line at the end of anything read-only. Users rely on it.

Find documents by frontmatter `type`, never by filename — that has already been a bug once (`779541c`). Assume the notebook you are running against is empty, because on a fresh clone it is.

A new command has to land in four places or it does not really exist: its own file, the Directory Structure tree in `README.md`, the Commands section in `README.md`, and the Commands list in `CLAUDE.md`. `CLAUDE.md` is the one the AI reads at session start.

Run `/yacho-mode` before you start. It routes to the command-change playbook, which is this list with the checks attached.
