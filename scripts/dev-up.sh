#!/usr/bin/env bash
# Spin up the local Keycloak dev stack and import the greyvetro realm.
#
# Usage:
#   ./scripts/dev-up.sh
#
# On first run, copies .env.local.example → .env.local if it doesn't exist yet.
# Edit .env.local to override KC_DB_PASSWORD / KC_ADMIN_PASSWORD.

set -euo pipefail
cd "$(dirname "$0")/.."

ENV_FILE=".env.local"

if [[ ! -f "$ENV_FILE" ]]; then
  cp .env.local.example "$ENV_FILE"
  echo "Created $ENV_FILE from .env.local.example — edit it if you need custom passwords."
fi

echo ""
echo "Starting Postgres + Keycloak..."
echo "(Realm import runs automatically on first boot via --import-realm)"
docker compose --env-file "$ENV_FILE" up -d

echo ""
echo "Waiting for Keycloak to pass its health check (this takes ~60–90s on first boot)..."
until docker inspect --format='{{.State.Health.Status}}' greyvetro-keycloak 2>/dev/null | grep -q "healthy"; do
  printf "."
  sleep 5
done
echo " ready."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Keycloak is ready"
echo ""
echo "  Admin console : http://localhost:8080/admin"
echo "  Realm         : greyvetro"
echo "  Admin login   : admin / $(grep KC_ADMIN_PASSWORD "$ENV_FILE" | cut -d= -f2)"
echo ""
echo "  Test users (password in realm-config/greyvetro-realm.yaml):"
echo "    superadmin / SuperAdm@Local1   → SuperAdmin"
echo "    storemgr   / StoreM@Local1     → StoreManager, ShiftLead"
echo "    cashier    / Cashier@Local1    → Cashier"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
