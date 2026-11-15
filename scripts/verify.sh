#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="observabilidad"

kubectl -n "$NAMESPACE" get deployment,replicaset,pods,service -o wide
