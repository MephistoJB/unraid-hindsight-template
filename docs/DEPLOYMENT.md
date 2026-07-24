# Deployment

1. Verify centralserver can resolve and reach `macserver:11434`.
2. Verify `qwen3-coder:30b` is available through Ollama's `/v1/models`.
3. Prefer the existing PostgreSQL 15+ service and create a dedicated
   `hindsight` role, database, schema, and the `vector` and `pg_trgm`
   extensions.
4. Create `/mnt/user/appdata/hindsight/cache` and set Hindsight UID 1000
   ownership on it.
5. Generate independent random database, API, and Control Plane keys.
6. Store them in a root-only `.env` file outside the repository.
7. Validate and deploy `compose/external-postgres.yaml` through Komodo. Use
   `compose/compose.yaml` only when no suitable PostgreSQL service exists.
8. Wait for PostgreSQL, model warmup, migrations, and Hindsight health.
9. Run direct retain, recall, contradiction, deletion, restart, privacy, and
   latency tests before changing Hermes.

Do not expose port 8888 or 9999 to the public internet. Restrict access to LAN
and Tailscale at the network layer.
