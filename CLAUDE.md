# Yacho — AI Assistant Instructions

This is a yacho notebook — an AI-augmented field notebook for tracking priorities, planning work, cataloging issues, and capturing reference material.

## Session Start

Every session, read these two files first:

1. **`priority-tracker.md`** (or the project-specific one) — understand what's active
2. **The most recent `weekly/*.md`** — understand what's planned this week

If neither exists yet, ask what the user is working on and help them create both.

## Artifact Types

| Type | Purpose | Update When |
|------|---------|-------------|
| **Priority Tracker** | Single source of truth for what matters now | Every session — check status, reorder if needed |
| **Weekly Doc** | This week's plan with daily breakdown | Start of week (create), end of week (review) |
| **Daily Log** | What actually happened today | End of day or during session |
| **Reference Sheet** | Dense, scannable lookup tables | When you learn stable facts worth recording |
| **Issue Catalog** | Troubleshooting log with root cause + fix | When a problem is diagnosed and resolved |
| **Runbook** | Step-by-step procedures for repeatable tasks | When a process is validated end-to-end |
| **Work Tracker** | Atomic implementation steps for a specific task | When breaking down a multi-step deliverable |

## Conventions

### Frontmatter

Every active document gets YAML frontmatter:

```yaml
---
type: tracker | weekly | daily | reference | issue-catalog | runbook | work-tracker
status: active | draft | archived
updated: YYYY-MM-DD
project: project-name
---
```

### Status Indicators

Use these consistently in all checklists:

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Done |
| `[-]` | Cancelled / won't do |

### Cross-Linking

Use wiki-link syntax: `[[path/to/file]]` or `[[path/to/file|Display Name]]`

Every document should have a `**Back to:** [[parent-readme]]` link near the top for reversible navigation.

### Writing Style

- **Reference sheets**: tables over prose, dense and scannable
- **Issue catalogs**: capture root cause, resolution, AND prevention
- **Weekly docs**: concrete deliverables, not vague intentions
- **Runbooks**: every step has an expected result so you know it worked

## AI Behavior

### Do

- Update the priority tracker when you learn something changed
- Create reference sheets when you encounter dense, reusable information
- Log issues with root cause and prevention when debugging
- Save memories for context that should persist across sessions
- Keep responses concise — the notebook is the artifact, not the chat

### Do Not

- Delete or archive files without explicit confirmation
- Rewrite logs, meeting notes, or records — these are historical artifacts
- Infer that something is complete from partial information — ask instead
- Add files outside the established directory structure without asking
- Over-organize — a flat folder with 10 files is better than 5 nested folders with 2 files each

## Memory

Use `.claude/memory/` to persist context across sessions:

- **User memories** — role, preferences, expertise, working style
- **Feedback memories** — corrections and confirmed approaches (include why)
- **Project memories** — goals, timelines, decisions, stakeholders
- **Reference memories** — pointers to external systems (URLs, dashboards, repos)

Index all memories in `.claude/memory/MEMORY.md`.

## Commands

- **`/notebook-sync`** — Read-only audit. Flags stale docs, broken links, status drift, and weekly gaps. Run weekly.

## Maintenance Cadence

**Weekly (5 minutes):**
1. Run `/notebook-sync` and review flagged items
2. Create a new weekly doc from the template
3. Update priority tracker with current status

**When a project or task wraps up:**
1. Set `status: archived` in frontmatter
2. Mark `[-]` or `[x]` in priority tracker
3. Capture lessons learned if any
