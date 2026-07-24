# Hermes

Use the built-in Hindsight provider in external mode:

```json
{
  "mode": "local_external",
  "api_url": "http://centralserver:8888",
  "bank_id": "hermes",
  "recall_budget": "low",
  "recall_prefetch_method": "recall",
  "recall_max_tokens": 1200,
  "recall_max_input_chars": 800,
  "recall_types": "world,experience",
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

When recalled personal data is injected into a Hermes prompt, the privacy
proxy must classify the complete augmented prompt and route it to the local
Qwen model. This is part of the mandatory end-to-end test.

