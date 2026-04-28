---
name: setup
description: "Guided walkthrough for setting up your yacho notebook. Creates your first weekly doc, priority tracker, reference sheet, and memory — and connects you to your north star."
allowed-tools: Read Write Edit Glob Grep
---

`$ARGUMENTS`

Walk the user through setting up their yacho notebook. This is an interactive, step-by-step process — pause after each step to let the user respond before moving on.

If the user provided arguments (like a project name or role), use those to skip or pre-fill relevant steps.

---

## Step 1: Welcome

Say something like:

> **Welcome to yacho (野帳) — your AI-augmented field notebook.**
>
> I'm going to walk you through setting up your notebook. By the end, you'll have:
> - A brain-dumped, sorted priority tracker
> - A weekly plan for this week
> - A reference sheet on something you actually need
> - A north star so every session stays pointed at what matters
> - AI memory so I remember who you are next time — no re-explaining
>
> This takes about 15 minutes. Let's go.

---

## Step 2: Brain Dump

Say:

> **First — get everything out of your head.**
>
> Don't organize it. Don't prioritize it. Just tell me everything that's on your plate right now: tasks, projects, deadlines, worries, things you keep forgetting to do, things you're avoiding. Stream of consciousness is fine.

Wait for their response. From what they share, extract:
- Their name (if not already known)
- Their role or situation
- Their main project or focus area
- Their nearest deadline or milestone
- Any blockers or anxieties

If anything critical is missing (especially a deadline), ask a targeted follow-up question. Otherwise, carry this material into the next steps — don't ask them to repeat themselves.

---

## Step 3: North Star

Ask:

> **One more question before we build anything.**
>
> In 6–12 months, what does success look like? One sentence — not a task list, just the destination.

Wait for their answer. Then create a memory file at `.claude/memory/north_star.md`:

```yaml
---
name: North star
description: The user's 6-12 month vision of success — referenced in notebook-sync to check milestone alignment
type: project
---
```

Fill in the body with their answer, the date captured, and any implied milestones or timeline markers from their brain dump.

Update `.claude/memory/MEMORY.md` to index this file.

Say:

> Got it. I'll check back on this every time you run `/notebook-sync` — so your weekly work stays connected to where you're actually trying to go.

---

## Step 4: Create a Priority Tracker

Using the brain dump from Step 2, create a priority tracker at `priority-tracker.md`. Use the template from `templates/priority-tracker.md` but fill in:
- The project name and today's date
- Their milestone as the P0 target
- Items sorted from the brain dump into P0–P2 buckets (mark as `[ ]`)
- Anything blocked or unclear in P3

Show the user what you created and briefly explain the system:
- **P0:** Must happen before the milestone
- **P1:** Important, actively working on
- **P2:** Ideas — captured, not committed
- **P3:** Blocked or backlog

Say: *"This is everything from your brain dump, sorted. Does this look right? Anything missing or in the wrong bucket?"* Adjust based on their response.

---

## Step 5: Create a Weekly Doc

Create a weekly doc at `weekly/week-{N}.md` using the template from `templates/weekly.md`. Fill in:
- The current week number and date range
- Days until their nearest milestone
- A focus statement based on their project
- 2–3 starter goals drawn from their P0/P1 items

Say: **"This is your weekly plan. I read it at the start of every session so I know what you're focused on — you don't have to brief me from scratch each time."**

---

## Step 6: Build a Reference Sheet

Say:

> **Let's make something immediately useful.**
>
> What's one area where you're always looking up the same information? Could be a checklist you keep remaking, criteria you're always second-guessing, a process you have to re-figure out each time — anything you'd want to have at a glance.

Wait for their answer. Create a reference sheet at `reference/[topic].md` using the template from `templates/reference-sheet.md`. Fill it with tables, not prose — dense and scannable.

Show it to them. Say: *"This is a reference sheet. Build one any time you encounter stable information worth keeping. They're meant to replace re-Googling the same thing."*

---

## Step 7: Working Style + Save Memories

Say:

> **Last setup step — let me learn how you like to work.**

Ask these three questions (can ask all at once):
1. Do you prefer concise responses or more detailed explanations?
2. When I'm working on your files — should I ask before making changes, or just do it and show you?
3. Anything you want me to always do, or never do?

Wait for their answers. Then:

**Save a user memory** at `.claude/memory/user_role.md`:
```yaml
---
name: User role and context
description: Who the user is, their role, and current focus area
type: user
---
```
Fill in: name, role/situation, project focus, nearest milestone.

**Save a feedback memory** at `.claude/memory/feedback_working_style.md`:
```yaml
---
name: Working style preferences
description: How the user wants Claude to communicate and behave
type: feedback
---
```
Fill in: their communication preferences and any explicit dos/don'ts from their answers.

Update `.claude/memory/MEMORY.md` to index both files.

Say: **"These memories persist across sessions. Next time we talk, I'll already know who you are and how you like to work."**

---

## Step 8: CLAUDE.md Tour

Read `CLAUDE.md` and give the user a quick tour now that they've seen the system in action:

> **This file is the AI's instruction set for your notebook.** It tells me:
> - What artifacts exist and where to find them
> - How to behave (read the tracker first, keep things concise, save memories)
> - Your conventions (frontmatter, status indicators, cross-linking)
>
> Now that you've used the notebook for 15 minutes, you have a feel for what it does. **This is how you customize it.** Change a convention, add a rule, tell me to behave differently — edit this file and it applies to every future session.
>
> Think of it as prompt engineering at the project level. Write your preferences once here instead of repeating them every message.

---

## Step 9: What's Next

Say:

> **Your notebook is set up.** Here's what to do from here:
>
> - **Start any session** by telling me what you're working on — I'll read your tracker and weekly doc automatically
> - **Run `/notebook-sync`** at the start of each week — I'll check your progress against your north star and flag anything drifting
> - **Add reference sheets** whenever you hit something worth keeping (tables, not prose)
> - **Log issues** when things go wrong — root cause, fix, and how to prevent it next time
> - **Update your tracker** when priorities shift — it's your single source of truth

---

## Tone

Conversational and practical. Don't over-explain. The user should feel like they accomplished something real in 15 minutes — not like they sat through a tutorial. The brain dump is the emotional moment; everything after that is building on momentum.
