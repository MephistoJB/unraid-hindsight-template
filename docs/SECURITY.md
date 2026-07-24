# Security

Hindsight `0.8.5` is unauthenticated by default. This deployment explicitly
enables `ApiKeyTenantExtension`, protects the Control Plane with a separate
access key, and disables MCP and telemetry traces.

The official image is digest pinned and signed upstream with Cosign. Its
Control Plane build uses an unlocked `npm install`, and the upstream release
workflow has its image smoke test commented out. Treat every version update as
a new review: verify the signature, inspect the source diff, pin the new digest,
and run the complete smoke test.

The official full image contains CPU-only PyTorch. Passing an NVIDIA GPU does
not accelerate local embedding or reranking. A GPU needs a reviewed custom
image or external TEI services, which are intentionally outside this minimal
architecture.

Memory content remains in PostgreSQL, its WAL, and backups according to their
retention policies. API deletion is not secure erasure from historical backups.

Unraid masks secret fields in its UI but stores template values on the flash
drive. Prefer the Komodo Compose deployment with a root-only `.env` file.

