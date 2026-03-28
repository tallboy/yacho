---
type: tracker
project: wx
status: active
updated: 2026-03-26
---

# Priority Tracker — wx CLI

**Back to:** [[README|wx Overview]] | [[../README|Notebook Root]]

---

## P0 — Current sprint

- [ ] **5-day forecast display** — API call is working, need to format output as a table using tablewriter. Handle edge cases: locations where forecast data is sparse, units toggle (F/C). Target: clean enough to screenshot for the README.

---

## P1 — Next up

- [ ] **Location favorites** — save/list/delete named locations. `wx save home "Seattle, WA"`, `wx home`, `wx list`, `wx delete home`. Store in config file (`~/.wx/config.yaml`).
- [ ] **Config file setup** — Viper integration. Store API key, default units, default location, saved favorites. Should create config on first run with a setup wizard (`wx init`).

---

## P2 — After MVP

- [ ] **Weather alerts** — show active NWS alerts for a location. Separate API (weather.gov), US-only for now.
- [ ] **Color output** — blue for cold, red for hot, yellow for sun, gray for overcast. Use lipgloss or fatih/color. Make it optional (respect `NO_COLOR` env var).
- [ ] **Hourly forecast** — next 12 hours in a compact format. Useful for "do I need an umbrella this afternoon" use case.

---

## P3 — Someday

- [ ] **Homebrew formula** — write the formula, test on a clean machine, submit to homebrew-core or host a personal tap.
- [ ] **CI/CD** — GitHub Actions for test, lint, build. GoReleaser for tagged releases. Cross-compile for Linux/macOS/Windows.
- [ ] **Weather history** — "what was the weather last Tuesday?" — would need to cache or use a different API.

---

## Session Notes

### 2026-03-26
- Got the 5-day API call working. Response parsing is clean but the table formatting is ugly — need to spend time on alignment and truncation for narrow terminals.
- Realized I need to handle the case where OpenWeather returns fewer than 5 days of data for some smaller cities. Added a TODO.

### 2026-03-19
- Basic current-weather lookup is done. Feels good to use. The output formatting with the "feels like" line was a nice touch — stole the idea from `wttr.in`.
- Cobra subcommand structure is set up: `wx [location]`, `wx forecast [location]`, `wx config`.
