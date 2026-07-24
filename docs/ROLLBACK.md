# Rollback

1. Set Hermes' memory provider back to the previous provider or empty value.
2. Redeploy Hermes and verify normal chat without Hindsight.
3. Stop the Hindsight stack.
4. Keep the dedicated PostgreSQL data directory until rollback is accepted.
5. Remove the stack only after exporting any required memory bank.
6. Delete PostgreSQL data and backups only with explicit approval.

Image rollback does not imply database migration rollback. Restore a matching
database backup before starting an older Hindsight version.

