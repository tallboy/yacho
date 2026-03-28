# Work — Platform Migration

**Back to:** [[../README|Notebook Root]]

---

## Context

We're extracting a Rails monolith into services at Fieldmark (series B, ~120 engineers). The monolith has been accumulating complexity for six years and deployments take 45 minutes. The first extraction target is the auth service — it has the clearest domain boundary and the most to gain from independent scaling.

I'm leading the auth extraction. Our team is four engineers: me, Priya (senior, strong on infrastructure), David (mid-level, knows the monolith best), and Maya (just joined W13, coming from a Django background). We report to Kenji (engineering manager).

**Timeline:** Auth service fully extracted and handling production traffic by end of Q2. API contracts finalized by April 4, load testing complete by April 11, staged rollout starts April 21.

---

## Key Links

| Resource | Link |
|----------|------|
| Jira board | https://fieldmark.atlassian.net/board/platform-migration |
| Staging environment | https://auth-staging.internal.fieldmark.dev |
| Slack channel | #platform-migration |
| Architecture RFC | https://fieldmark.atlassian.net/wiki/auth-extraction-rfc |
| Monolith repo | https://github.com/fieldmark/fieldmark-core |
| New auth service repo | https://github.com/fieldmark/auth-service |

---

## Architecture Notes

The monolith currently handles auth through a mix of Devise and custom middleware. Session management, OAuth provider integration, and API token auth are all tangled together. The extraction plan:

1. **New auth service** — Go, handles token issuance, validation, and OAuth flows
2. **Thin adapter in monolith** — calls auth service instead of local Devise, maintains backward compatibility during migration
3. **Gradual traffic shift** — feature-flagged per-endpoint, monitored with custom dashboards
4. **Monolith cleanup** — remove Devise and legacy middleware after full cutover

Open question: gRPC vs REST for inter-service communication. Platform team is benchmarking. Leaning gRPC for internal calls, REST gateway for external consumers.

---

## Team

| Person | Role | Notes |
|--------|------|-------|
| Sam (me) | Tech lead | Owns API contracts, coordinates with platform team |
| Priya | Senior engineer | Leading infrastructure/deployment pipeline |
| David | Mid-level engineer | Monolith adapter layer, knows the legacy auth code best |
| Maya | Engineer (new, W13) | Ramping up, starting with integration test scaffolding |
| Kenji | Engineering manager | Weekly 1:1 Mondays, shields us from scope creep |

---

## Documents

- [[priority-tracker|Priority Tracker]] — current priorities, P0-P3
- [[weekly/2026-W14|This Week (W14)]] — API contracts focus
