#!/usr/bin/env bash
# Creates Kubernetes secrets for local DEV from environment variables.
# Run once after `k3d cluster create` and before `helm install`.
#
# Usage:
#   export KC_DB_PASSWORD=changeme
#   export KC_ADMIN_PASSWORD=changeme
#   ./scripts/local-secrets.sh

set -euo pipefail

NAMESPACE=greyvetro

: "${KC_DB_PASSWORD:?Set KC_DB_PASSWORD before running this script}"
: "${KC_ADMIN_PASSWORD:?Set KC_ADMIN_PASSWORD before running this script}"

kubectl apply -f k8s/namespace.yaml

kubectl create secret generic keycloak-db-credentials \
  --from-literal=password="$KC_DB_PASSWORD" \
  --namespace="$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic keycloak-admin-credentials \
  --from-literal=admin-password="$KC_ADMIN_PASSWORD" \
  --namespace="$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Secrets applied to namespace '$NAMESPACE'."
