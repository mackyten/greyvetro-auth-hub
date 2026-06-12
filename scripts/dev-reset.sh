#!/usr/bin/env bash
# Tear down the local stack and wipe the Postgres volume.
# Use this when you want a clean slate — realm re-imported from scratch.
#
# Usage:
#   ./scripts/dev-reset.sh

set -euo pipefail
cd "$(dirname "$0")/.."

ENV_FILE=".env.local"
[[ ! -f "$ENV_FILE" ]] && ENV_FILE=".env.local.example"

echo "Stopping and removing containers + postgres_data volume..."
docker compose --env-file "$ENV_FILE" down -v --remove-orphans

echo ""
echo "Done. Run ./scripts/dev-up.sh to start fresh."
