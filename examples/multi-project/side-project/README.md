# Side Project — wx

**Back to:** [[../README|Notebook Root]]

---

## What Is This

`wx` is a CLI weather tool written in Go. You give it a location, it gives you the weather. That's it.

```
$ wx seattle
Seattle, WA — 54°F, overcast
  Feels like: 51°F | Humidity: 78% | Wind: 12 mph SW

$ wx seattle --forecast
Seattle, WA — 5-Day Forecast
┌───────────┬───────┬───────┬──────────────┐
│ Day       │ High  │ Low   │ Conditions   │
├───────────┼───────┼───────┼──────────────┤
│ Mon 3/30  │ 56°F  │ 44°F  │ Partly cloudy│
│ Tue 3/31  │ 52°F  │ 41°F  │ Rain         │
│ ...       │       │       │              │
└───────────┴───────┴───────┴──────────────┘
```

**Why:** Learning Go properly (not just tutorials), building something I'd actually use daily, and having a polished portfolio piece that shows CLI design, API integration, and clean code.

---

## Current Status

Basic current-weather lookup works end-to-end. You can pass a city name or zip code, it hits the OpenWeather API, and prints a formatted result. What's left for MVP:

- **5-day forecast** — in progress, API call works but need the table display
- **Location favorites** — save locations so you can do `wx home` instead of typing the city every time
- **Config file** — store API key, default units (F/C), default location

---

## Tech Stack

| Component | Choice | Notes |
|-----------|--------|-------|
| Language | Go 1.22 | |
| Weather API | OpenWeather (free tier) | 1,000 calls/day, more than enough |
| CLI framework | Cobra | Standard for Go CLIs |
| HTTP client | net/http | No need for a library |
| Table output | tablewriter | For forecast display |
| Config | Viper | Cobra's companion, handles YAML/env/flags |
| Testing | Go stdlib + testify | |

---

## Key Links

| Resource | Link |
|----------|------|
| Repo | https://github.com/samcodes/wx |
| OpenWeather API docs | https://openweathermap.org/api |
| Go CLI patterns reference | https://clig.dev |

---

## Documents

- [[priority-tracker|Priority Tracker]] — feature roadmap
