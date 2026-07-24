# Hermes

Use the built-in Hindsight provider in external mode:

```json
{
  "mode": "local_external",
  "api_url": "http://centralserver:8888",
  "bank_id": "hermes-primary-v2",
  "recall_budget": "low",
  "recall_prefetch_method": "recall",
  "recall_max_tokens": 1200,
  "recall_max_input_chars": 800,
  "recall_types": ["world", "experience"],
  "recall_min_score": 0.1,
  "auto_recall": true,
  "auto_retain": true,
  "retain_async": true,
  "retain_every_n_turns": 1,
  "memory_mode": "context"
}
```

Store the Hindsight API key as `HINDSIGHT_API_KEY` in Hermes' secret
environment. Start with observations disabled and raw fact recall enabled.
Enable observations only if measured recall quality justifies its additional
LLM work.

## Hermes compatibility override

The Hermes build tested on 2026-07-24 only consumed a post-turn background
prefetch. API and WebUI requests construct a fresh agent, so current-turn
recall was empty. It also uses Hindsight client 0.6.1, whose generated
`RecallResult` drops relevance scores.

Mount the reviewed override read-only:

```yaml
volumes:
  - /opt/komodo/hermes-agent/overrides/hindsight.py:/opt/hermes/plugins/memory/hindsight/__init__.py:ro
```

Copy
[`overrides/hermes/plugins/memory/hindsight/__init__.py`](../overrides/hermes/plugins/memory/hindsight/__init__.py)
to that host path. The override adds current-turn recall, associates cached
results with their query, filters REST recall results by `recall_min_score`,
and removes the bank ID from the model prompt so privacy structure hashes stay
stable. Remove the override after upstream Hermes contains equivalent fixes.

When recalled personal data is injected into a Hermes prompt, the privacy
proxy must classify the complete augmented prompt and route it to the local
Qwen model. This is part of the mandatory end-to-end test.
