# Hindsight for Unraid

Security-oriented Unraid template and Komodo Compose stack for
[Hindsight](https://github.com/vectorize-io/hindsight).

The deployment keeps memory processing local:

- Hindsight and PostgreSQL/pgvector run on the Unraid host.
- Hindsight uses an OpenAI-compatible Ollama endpoint on `macserver`.
- Hermes connects to Hindsight in `local_external` mode.
- API and Control Plane authentication are enabled.
- MCP, telemetry traces, bank IDs in metrics, and access logs are disabled.
- Images are versioned and digest pinned.

## Install the Unraid template

Add this repository as a Docker template repository:

```text
https://github.com/MephistoJB/unraid-hindsight-template
```

The single-container template expects an existing PostgreSQL 15+ database with
`vector` and `pg_trgm`. For a complete deployment, use
[`compose/compose.yaml`](compose/compose.yaml), which includes a dedicated
PostgreSQL 16/pgvector service.

## Required secrets

Create `.env` from [`.env.example`](.env.example). Never commit the generated
database password or access keys. `HINDSIGHT_API_KEY` and
`HINDSIGHT_CP_DATAPLANE_API_KEY` must contain the same value;
`HINDSIGHT_CP_ACCESS_KEY` must be different.

## Validate

```bash
./scripts/validate-template.sh
docker compose --env-file .env -f compose/compose.yaml config --quiet
HINDSIGHT_API_KEY=... ./scripts/e2e-memory-test.sh
```

See [deployment](docs/DEPLOYMENT.md), [security](docs/SECURITY.md),
[Hermes integration](docs/HERMES.md), and [rollback](docs/ROLLBACK.md).

## Upstream pin

- Hindsight release: `0.8.5`
- Source commit: `705757f362552918dfb0242906cb8466de320378`
- Multi-platform image digest:
  `sha256:0710076cd1539b4f89537d2e5b0ea1e4d179885bc12809a56cf748c538c8c4fb`
- Centralserver AMD64 manifest:
  `sha256:2a9dfdb1081f0cc14d77b2047a5e979e9b3d5325d9db3e3ca45e3bf359dc8b3f`

The upstream release publishes keyless Cosign signatures. Its release workflow
does not currently run the commented-out container smoke test, so this
repository performs its own runtime checks before Hermes is switched.
