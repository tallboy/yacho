# yacho 野帳

A structured markdown workspace that gives AI assistants persistent context across conversations.

---

## The Problem

AI assistants forget everything between sessions. You re-explain context, lose track of decisions, and never build momentum. Yacho solves this by giving the AI a file system it can read and write to — markdown files for tracking priorities, planning weeks, cataloging issues, and capturing reference material, plus a memory system that persists what the AI learns about you and your work.

After a few sessions, the AI knows your project, your preferences, and your working style. You stop repeating yourself and start compounding.

## Principles

- **Markdown for everything** — versionable, searchable, AI-readable, tool-agnostic
- **Structure enables AI** — templates and conventions mean the AI knows where to look and how to write
- **Memory compounds** — each session builds on the last instead of starting from zero
- **Reference over recall** — capture dense, scannable artifacts you look up later
- **The notebook is yours** — adapt templates, add new ones, evolve the structure

---

## Quick Start

**1. Clone and open**

```bash
git clone https://github.com/tallboy/yacho.git my-notebook
cd my-notebook
```

**2. Open in your AI tool**

Works with [Claude Code](https://claude.ai/code), Cursor, Windsurf, or any AI assistant with file access. The AI reads `CLAUDE.md` for instructions automatically.

**3. Start your first session**

Paste this into your AI assistant:

```
Read CLAUDE.md, then help me set up this notebook. I'm working on [describe your work].
Let's create a priority tracker and plan this week.
```

That's it. The AI will create your first priority tracker and weekly doc from the templates.

**4. Ongoing use**

Each session, the AI reads your priority tracker and current weekly doc to pick up where you left off. Run `/notebook-sync` weekly to catch stale docs and drift.

---

## Directory Structure

```
yacho/
├── CLAUDE.md                      # AI assistant instructions (read this first)
├── README.md                      # You are here
├── .gitignore
├── .claude/
│   ├── memory/
│   │   └── MEMORY.md              # Persistent memory index
│   └── commands/
│       └── notebook-sync.md       # Weekly audit command
├── templates/
│   ├── weekly.md                  # Weekly planning
│   ├── daily-log.md               # Daily log with time tiers
│   ├── priority-tracker.md        # Priority management (P0-P3)
│   ├── reference-sheet.md         # Dense lookup tables
│   ├── issue-catalog.md           # Troubleshooting log
│   ├── runbook.md                 # Step-by-step procedures
│   └── work-tracker.md            # Atomic implementation steps
├── examples/
│   ├── student/                   # Filled-in example: college student
│   └── multi-project/             # Filled-in example: working professional
├── weekly/                        # Your weekly plans (empty to start)
├── reference/                     # Your reference material (empty)
├── issues/                        # Your troubleshooting logs (empty)
├── runbooks/                      # Your procedures (empty)
└── scratch/                       # Ephemeral workspace (gitignored)
```

---

## Templates

| Template | Purpose | When to Create |
|----------|---------|---------------|
| **[priority-tracker](templates/priority-tracker.md)** | Single source of truth for what matters now. P0–P3 tiers with decisions waiting. | Once per project. Update every session. |
| **[weekly](templates/weekly.md)** | This week's plan with daily breakdown and end-of-week review. | Every Monday (or Sunday night). |
| **[daily-log](templates/daily-log.md)** | What actually happened today. Time-tier system: 15 / 30 / 60 min. | Daily, if you want finer grain than weekly. |
| **[work-tracker](templates/work-tracker.md)** | Atomic implementation steps for a specific task. Each step is independently verifiable. | When tackling a multi-step deliverable. |
| **[reference-sheet](templates/reference-sheet.md)** | Dense, scannable lookup tables. Tables over prose. | When you encounter stable facts worth recording. |
| **[issue-catalog](templates/issue-catalog.md)** | Troubleshooting log: symptom → root cause → fix → prevention. | When a problem is diagnosed and resolved. |
| **[runbook](templates/runbook.md)** | Step-by-step procedure with pre-flight checks and validation. | When a process is validated end-to-end. |

---

## Conventions

### Frontmatter

Every active document gets YAML frontmatter so the AI (and `/notebook-sync`) can audit it:

```yaml
---
type: tracker | weekly | daily | reference | issue-catalog | runbook | work-tracker
status: active | draft | archived
updated: YYYY-MM-DD
project: project-name
---
```

Not every file needs frontmatter. Skip it for archives, one-off notes, and scratch files. Focus on the documents you actively maintain.

### Status Indicators

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Done |
| `[-]` | Cancelled / won't do |

### Cross-Linking

Use wiki-link syntax for internal references:

```markdown
[[weekly/2026-W14]]
[[priority-tracker|Current Priorities]]
```

Add a `**Back to:** [[README]]` link near the top of every document for reversible navigation.

### Scratch Directory

The `scratch/` folder is gitignored — use it freely for ephemeral content: draft emails, temp data, working notes, experiments. Nothing in `scratch/` will be committed.

---

## Memory System

The `.claude/memory/` directory persists context across AI sessions. The AI saves memories automatically when it learns something worth remembering. Four types:

| Type | What to Save | Example |
|------|-------------|---------|
| **User** | Your role, preferences, expertise, working style | "Senior engineer, prefers terse responses, deep Go expertise" |
| **Feedback** | Corrections and confirmed approaches (with why) | "Don't mock the database — prior incident with mock/prod divergence" |
| **Project** | Goals, timelines, decisions, stakeholders | "API migration must ship by March 15 — compliance deadline" |
| **Reference** | Pointers to external systems | "Bug tracker is Linear project INGEST" |

Memories are indexed in `.claude/memory/MEMORY.md`. The AI reads this at the start of each session to recall prior context.

---

## Commands

### `/notebook-sync`

Read-only audit of your notebook. Flags issues without making changes.

```
/notebook-sync        # default: flag docs not updated in 14+ days
/notebook-sync 7      # stricter: 7-day threshold
```

**What it checks:**
- Stale documents (active but not updated recently)
- Status drift (priority tracker says "in progress" but weekly says "done")
- Weekly log gaps (missing weeks, incomplete items that disappeared)
- Broken wiki-links (targets that don't exist)

**Output:** A prioritized checklist you can work through in under 5 minutes.

Run this weekly, or after a burst of edits.

---

## Examples

Two filled-in examples show what a notebook looks like after a few weeks of use:

### [Student Example](examples/student/)

A college junior planning their semester: coursework, internship search, a side project, and study habits. Shows how to balance multiple commitments with different cadences.

### [Multi-Project Example](examples/multi-project/)

A working professional juggling: day job (platform migration), a side project (weather CLI tool), learning Portuguese, and planning a trip to Lisbon. Shows how to scale yacho across domains with cross-linking.

---

## Scaling to Multiple Projects

Start with a flat structure. When you outgrow it, nest under project directories:

```
my-notebook/
├── CLAUDE.md
├── work/
│   ├── README.md              # Project MOC (Map of Content)
│   ├── priority-tracker.md
│   └── weekly/
├── side-project/
│   ├── README.md
│   ├── priority-tracker.md
│   └── weekly/
├── learning/
│   ├── README.md
│   └── weekly/
├── templates/                 # Shared templates
└── scratch/
```

Each project gets its own priority tracker and weekly directory. Templates stay shared. The root `CLAUDE.md` tells the AI about all active projects.

---

## Tools

Yacho works with any AI tool that has file access:

| Tool | How to Use |
|------|-----------|
| **[Claude Code](https://claude.ai/code)** | Native support. Open the directory and start chatting. `/notebook-sync` works as a slash command. |
| **Cursor / Windsurf** | Open as a project. The AI reads `CLAUDE.md` automatically. |
| **Obsidian** | Use as a vault for visual editing. Wiki-links render as clickable links. |
| **VS Code + AI extension** | Open as a workspace. Point the AI at `CLAUDE.md`. |
| **Any markdown editor** | The files are plain markdown — edit them however you like. |

---

## Git Workflow

Commit regularly. Git history is your changelog.

```bash
git add -p                            # stage selectively
git commit -m "feat: [description]"   # commit messages capture "why"
git push origin main
```

The priority tracker and weekly docs are the most important files to keep committed — they're your paper trail for decisions and progress.

---

## FAQ

**Do I need Obsidian?**
No. Yacho is plain markdown files. Obsidian is nice for visual editing and wiki-link navigation, but any text editor works.

**How is this different from a todo app?**
Todo apps track tasks. Yacho tracks context — priorities, decisions, troubleshooting history, reference material. The AI reads all of this to give you better answers over time.

**What if I don't use all the templates?**
Start with just `priority-tracker.md` and `weekly.md`. Add others when you need them. Most people never use all seven, and that's fine.

**Can I use this for a team?**
Yacho is designed for individual notebooks. For team use, each person maintains their own notebook. Shared project context goes in the project's `CLAUDE.md` or `AGENTS.md`.

**How do I archive old content?**
Set `status: archived` in frontmatter and move to an `archive/` subfolder. `/notebook-sync` will skip archived files.

---

*The goal is not perfect organization — it's finding the right document in under 30 seconds and trusting that what you read is current.*
