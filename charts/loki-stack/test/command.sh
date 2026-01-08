#!/bin/bash

# Loki Stack Deployment Script
# Namespace: monitoring
# Components: Loki, Fluent Bit, Prometheus, Grafana with Persistent Volumes

set -e

NAMESPACE="monitoring"
RELEASE_NAME="grafana-stack"

echo "========================================="
echo "Loki Stack Deployment Script"
echo "========================================="
echo ""

echo "==> Adding Helm repositories..."
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add fluent https://fluent.github.io/helm-charts
echo ""
echo "==> Updating Helm dependencies..."
cd ../
helm dependency update

echo ""
echo "==> Creating '$NAMESPACE' namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "==> Installing $RELEASE_NAME in '$NAMESPACE' namespace..."
echo "    - Loki with 10Gi PV"
echo "    - Prometheus with 10Gi PV"
echo "    - Grafana with 5Gi PV"
echo "    - Alertmanager with 2Gi PV"
echo ""

# NOTE:
# - Kubernetes forbids updating StatefulSet fields like volumeClaimTemplates (PVC size/storageClass) in-place.
# - If you changed Loki persistence settings since the last install, Helm upgrade may fail with:
#     "updates to statefulset spec ... are forbidden"
# - To recover while KEEPING PVCs/data, you can recreate the Loki StatefulSet before upgrade:
#     RECREATE_LOKI_STATEFULSET=true bash command.sh
if [ "${RECREATE_LOKI_STATEFULSET:-false}" = "true" ]; then
  echo "==> RECREATE_LOKI_STATEFULSET=true: deleting Loki StatefulSet (PVCs will be kept)..."
  kubectl delete statefulset -n "$NAMESPACE" "$RELEASE_NAME-loki" --ignore-not-found=true
  echo ""
fi

helm upgrade --install $RELEASE_NAME . \
  --namespace $NAMESPACE \
  --values test/values.yaml \
  --wait

echo ""
echo "========================================="
echo "Deployment completed successfully!"
echo "========================================="
echo ""

echo "==> Checking pod status..."
kubectl get pods -n $NAMESPACE

echo ""
echo "==> Checking services..."
kubectl get svc -n $NAMESPACE

echo ""
echo "==> Checking persistent volume claims..."
kubectl get pvc -n $NAMESPACE

echo ""
echo "==> Discovering Grafana service/secret names..."
GRAFANA_SVC="$(kubectl get svc -n "$NAMESPACE" -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
GRAFANA_SECRET="$(kubectl get secret -n "$NAMESPACE" -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [ -z "$GRAFANA_SVC" ]; then
  GRAFANA_SVC="$RELEASE_NAME-grafana"
fi
if [ -z "$GRAFANA_SECRET" ]; then
  GRAFANA_SECRET="$RELEASE_NAME-grafana"
fi

echo ""
echo "========================================="
echo "Access Information"
echo "========================================="
echo ""

echo "==> Grafana Admin Password:"
echo "kubectl get secret -n $NAMESPACE $GRAFANA_SECRET -o jsonpath='{.data.admin-password}' | base64 --decode; echo"
echo ""

echo "==> Port-forward Grafana (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$GRAFANA_SVC 3000:80"
echo "Then access: http://localhost:3000"
echo "Username: admin"
echo ""

echo "==> Port-forward Prometheus (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-kube-prometheus-stack-prometheus 9090:9090"
echo "Then access: http://localhost:9090"
echo ""

echo "==> Port-forward Loki (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-loki 3100:3100"
echo "Then access: http://localhost:3100"
echo ""

echo "==> Port-forward Alertmanager (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-kube-prometheus-stack-alertmanager 9093:9093"
echo "Then access: http://localhost:9093"
echo ""

echo "========================================="
echo "Useful Commands"
echo "========================================="
echo ""
echo "# View logs from Fluent Bit:"
echo "kubectl logs -n $NAMESPACE -l app.kubernetes.io/name=fluent-bit -f"
echo ""
echo "# View logs from Loki:"
echo "kubectl logs -n $NAMESPACE -l app.kubernetes.io/name=loki -f"
echo ""
echo "# Uninstall the stack:"
echo "helm uninstall $RELEASE_NAME -n $NAMESPACE"
echo ""
echo "# Delete PVCs (after uninstall):"
echo "kubectl delete pvc -n $NAMESPACE --all"
echo ""