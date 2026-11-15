#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="observabilidad"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Error: kubectl no está instalado o no está en PATH." >&2
  exit 1
fi

kubectl apply -f "$ROOT_DIR/k8s/namespace.yaml"

read -rsp "Introduce una contraseña exclusiva para Grafana: " GRAFANA_ADMIN_PASSWORD
echo
if [[ -z "$GRAFANA_ADMIN_PASSWORD" ]]; then
  echo "Error: la contraseña no puede estar vacía." >&2
  exit 1
fi

kubectl -n "$NAMESPACE" create secret generic grafana-admin \
  --from-literal="password=$GRAFANA_ADMIN_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
unset GRAFANA_ADMIN_PASSWORD

kubectl apply -f "$ROOT_DIR/k8s/grafana.yaml"
kubectl -n "$NAMESPACE" rollout status deployment/grafana --timeout=180s

echo "Despliegue listo. Ejecuta: kubectl -n $NAMESPACE port-forward service/grafana 3000:3000"
