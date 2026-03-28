---
type: reference
project: "{{project-name}}"
status: active
updated: "{{YYYY-MM-DD}}"
---

# Reference Sheet — {{project-name}}

> [!info] This is a lookup file, not a narrative.
> Keep entries terse. If an item needs more than one line of explanation, it belongs in a separate document — link to it from here.

---

## Quick Reference

| Item | Value |
|------|-------|
| {{Project repo / location}} | {{URL or path}} |
| {{Primary environment}} | {{e.g., staging URL, server name, local port}} |
| {{Auth method}} | {{e.g., SSO, API key in vault, token in .env}} |
| {{Deploy cadence}} | {{e.g., weekly on Tuesdays, continuous, manual}} |
| {{Key config file}} | {{path/to/config}} |
| {{Version / release}} | {{current version or tag}} |

---

## Key Navigation / Access Paths

| Destination | How to Get There |
|-------------|-----------------|
| {{Admin panel}} | {{URL or sequence of clicks/commands}} |
| {{Logs}} | {{Where to find them and how to filter}} |
| {{Database}} | {{Connection string pattern or tool to use}} |
| {{CI/CD pipeline}} | {{URL or command}} |
| {{Documentation}} | {{URL or local path}} |

---

## Key Resources

| Resource | Purpose | Location |
|----------|---------|----------|
| {{Design doc / spec}} | {{Source of truth for requirements}} | {{URL}} |
| {{API docs}} | {{Endpoint reference}} | {{URL}} |
| {{Runbook}} | {{Operational procedures}} | {{path or URL}} |
| {{Shared drive / folder}} | {{Assets, decks, templates}} | {{URL}} |

---

## Common Commands / Scripts

```bash
# {{Build / compile}}
{{command here}}

# {{Run locally}}
{{command here}}

# {{Run tests}}
{{command here}}

# {{Deploy}}
{{command here}}

# {{Check status / health}}
{{command here}}
```

```bash
# {{Database / data tasks}}
{{command here}}

# {{Generate or update something}}
{{command here}}
```

> [!tip] Keep commands copy-pasteable.
> Include the full command with flags. Do not make the reader guess or remember arguments.

---

## Troubleshooting Quick Fixes

| Problem | Fix |
|---------|-----|
| {{Common error message or symptom}} | {{Exact command or step to resolve}} |
| {{Build fails after pull}} | {{e.g., rm -rf node_modules && npm install}} |
| {{Auth token expired}} | {{e.g., run `./scripts/refresh-token.sh`}} |
| {{Service not starting}} | {{e.g., check port conflict: `lsof -i :8080`}} |
| {{Stale data in UI}} | {{e.g., clear cache: Cmd+Shift+R or flush Redis}} |

---

## Contacts / Owners

| Area | Person | How to Reach |
|------|--------|-------------|
| {{Technical lead}} | {{Name}} | {{Slack handle, email, or calendar link}} |
| {{Product / requirements}} | {{Name}} | {{Contact method}} |
| {{Infrastructure / ops}} | {{Name}} | {{Contact method}} |
| {{External vendor / partner}} | {{Name or team}} | {{Contact method and SLA expectations}} |
