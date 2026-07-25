# Changelog

## Unreleased

- Keep assistant responses out of user-profile retention by default so model
  claims cannot be stored as user facts.
- Add a focused regression test for user-only retention.

## 0.1.0 - 2026-07-24

- Add digest-pinned Hindsight `0.8.5` Unraid template.
- Add complete PostgreSQL/pgvector and Hindsight Compose stack.
- Add authenticated API and Control Plane defaults.
- Add German multilingual embedding, reranking, and text-search defaults.
- Add validation, smoke-test, deployment, security, Hermes, and rollback docs.
- Add an external-PostgreSQL Compose variant for existing pgvector services.
- Add a Hermes current-turn recall and score-filter compatibility override.
- Document measured latency, privacy routing, persistence, and observation tests.
