# Validation results

Measured on 2026-07-24 after warmup:

| Test | Result |
| --- | --- |
| Unauthenticated API | HTTP 401 |
| Authenticated API | HTTP 200 |
| Initial retain | 8358 ms |
| Warm retain | 2919 ms |
| Warm recall | 765-821 ms |
| Persistence across Hindsight restart | Pass |
| Bank deletion from bank listing | Pass |
| Hermes CLI current-turn recall | Pass |
| Hermes Gateway current-turn recall | Pass |
| Recalled private data routed locally | Pass, `rules_private` |
| Unrelated safe request routed to Codex | Pass, `classifier_safe` |
| Privacy classifier routing time | 802 ms |
| Hindsight steady memory | about 1.4 GiB |
| PostgreSQL restart count during deployment | 0 |

Observations were tested with Qwen and auto-consolidation enabled. A one-memory
consolidation took about 12 seconds; backlog batches took 16-21 seconds. Recall
remained about 0.8 seconds. Observations and auto-consolidation are therefore
disabled for the latency-oriented default.

Deleted bank IDs should not be reused immediately. During testing, recreating
the same ID could expose stale results while deletion completed. Production
uses a fresh versioned bank ID.
