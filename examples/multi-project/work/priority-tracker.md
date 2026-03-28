---
type: tracker
project: work
status: active
updated: 2026-03-28
---

# Priority Tracker — Platform Migration

**Back to:** [[README|Work Overview]] | [[../README|Notebook Root]]

---

## P0 — Must happen before next milestone

- [ ] **Auth service API contracts finalized** — OpenAPI spec reviewed and approved by team + platform team. Due April 4. Draft is ~80% done, need to nail down token refresh flow and error response format.
- [ ] **Load testing plan and scenarios documented** — need to define target throughput (current monolith does ~2k auth requests/sec at peak), latency budgets, and failure scenarios. Due April 11.

---

## P1 — Important, in progress

- [ ] **Deprecate legacy auth middleware** — David is mapping all call sites in the monolith. Found 14 controllers still using the old `authenticate!` helper directly instead of going through the middleware stack. Need to consolidate before we can swap in the adapter.
- [ ] **Onboard Maya** — started W13. She's got her dev environment up, has read the RFC, and is working through the codebase. Goal: she owns integration test scaffolding by W15. 1:1s Monday and Wednesday this week.
- [ ] **Integration test scaffolding** — set up test harness that can run auth flows against both monolith and new service, so we can verify behavioral parity. Maya starting on this Tuesday.

---

## P2 — Ideas surfaced, pending direction

- [ ] **Observability dashboard for new services** — Priya has a rough Grafana dashboard but we need auth-specific panels: token issuance rate, validation latency p50/p95/p99, OAuth flow completion rate. Not urgent until we start traffic shifting.
- [ ] **Documentation migration plan** — the current auth docs are scattered across Confluence, inline code comments, and a stale README. Need to consolidate before the old code gets deleted. Low urgency but will bite us later.
- [ ] **Session migration strategy** — existing sessions are stored in Redis via the monolith. Need a plan for how to handle in-flight sessions during cutover. Could do dual-read or force re-auth. Research needed.

---

## P3 — Backlog / Blocked

- [ ] **Clean up feature flags from Q4 launch** — there are 11 stale flags from the payments redesign launch in November. Not blocking anything but cluttering the codebase. Good task for a slow Friday.
- [ ] **Evaluate service mesh** — Kenji asked about Istio vs Linkerd for when we have more services. Way too early, parking until we have at least three services running. Revisit: Q3.

---

## Decisions Waiting

| Decision | Owner | Waiting Since | Context |
|----------|-------|---------------|---------|
| gRPC vs REST for inter-service calls | Platform team (Yara) | 2026-03-18 | Yara's team is benchmarking both with our expected traffic patterns. Leaning gRPC but concerns about debugging ergonomics. Need answer by April 4 to finalize API contracts. |
| Token rotation policy — 15 min vs 1 hour | Sam + security team | 2026-03-25 | Security wants 15-min rotation, product worried about UX for long-running workflows. Meeting scheduled April 1. |

---

## Session Notes

### 2026-03-28
- Updated P0 items with current status — API contracts draft at ~80%
- Maya ramping faster than expected, moving integration test scaffolding from P2 to P1
- Added session migration strategy to P2 — Priya raised this in standup, we hadn't considered in-flight sessions

### 2026-03-21
- Kicked off W13, Maya's first week
- David found 14 controllers with direct `authenticate!` calls — worse than we thought, was estimating 5-6
- Platform team confirmed they'll have gRPC benchmark results by end of March
