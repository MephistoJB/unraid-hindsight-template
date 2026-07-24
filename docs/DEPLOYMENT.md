# Deployment

1. Verify centralserver can resolve and reach `macserver:11434`.
2. Verify `qwen3-coder:30b` is available through Ollama's `/v1/models`.
3. Create `/mnt/user/appdata/hindsight/{postgres,cache}`.
4. Set PostgreSQL ownership on `postgres` and Hindsight UID 1000 ownership on
   `cache`.
5. Generate independent random database, API, and Control Plane keys.
6. Store them in a root-only `.env` file outside the repository.
7. Validate and deploy `compose/compose.yaml` through Komodo.
8. Wait for PostgreSQL, model warmup, migrations, and Hindsight health.
9. Run direct retain, recall, contradiction, deletion, restart, privacy, and
   latency tests before changing Hermes.

Do not expose port 8888 or 9999 to the public internet. Restrict access to LAN
and Tailscale at the network layer.

