---
type: reference
project: "{{project-name}}"
status: active
updated: "{{YYYY-MM-DD}}"
---

# MCP Connectors — {{project-name}}

> [!info] What this tracks
> yacho itself is tool-agnostic markdown — it doesn't depend on any connector. But most of the workflows people build on top of it (plan-my-day style planning, "what's on my plate", comms drafting) lean on connected tools: mail, calendar, chat, ticketing. This sheet is just a status board so you know what's actually wired up before an AI assistant tries to use it — and so you don't re-discover the same gap every session.

**How to check current status:** in Claude Code, run `/mcp` to see configured servers, or ask the assistant to search for a tool by name — if it's not found, it's either unauthorized or not configured at all (see the Status column below for the difference).

---

## Status Board

| Connector | Status | Provides | Notes |
|-----------|--------|----------|-------|
| Microsoft 365 | {{Connected / Needs auth / Not configured}} | Mail, calendar, OneDrive, SharePoint, Teams (list only), To Do, contacts | {{e.g. "no Teams *send* tool — draft messages via /compose and paste manually"}} |
| Google Workspace | {{Connected / Needs auth / Not configured}} | Gmail, Calendar, Drive, Docs, Sheets | {{note if this requires a separate MCP server add, not just an auth click}} |
| Slack | {{Connected / Needs auth / Not configured}} | Channels, DMs, search | |
| GitHub / GHE | {{Connected / Needs auth / Not configured}} | Issues, PRs, repo search — often just the `gh` CLI, no MCP server needed | |
| {{Internal ticketing / ITSM}} | {{Connected / Needs auth / Not configured}} | {{e.g. incidents, changes, work items}} | |
| {{Other}} | | | |

---

## Two different kinds of "not available"

1. **Needs auth** — the server is configured but not authorized for this session. Fix: authorize via the host's connector settings (claude.ai connectors) or re-run the interactive auth flow (`claude mcp` / `/mcp` in an interactive session). An assistant running non-interactively (headless, cron) cannot do this step itself — it can only tell you it's blocked.
2. **Not configured** — no server exists for this connector at all. Fix: add one (`claude mcp add ...`, or your host's connector marketplace). This is a setup task, not an auth click — flag it as a gap rather than assuming it's "just permissions."

## Common Gaps Worth Checking

- **Teams/Slack send** — list/search tools are common; *send a message* tools are less common (Graph API app registration, bot setup). If missing, route drafted messages through `/compose` for manual paste instead of assuming the assistant can send directly.
- **Google Workspace** — often simply never added as a server (distinct from "needs auth"). Worth an explicit check rather than assuming parity with Microsoft 365 if your org uses Google.
- **Ticketing/ITSM write access** — read (search, list) is often available before write (create, update) is approved — check both directions separately.
