#!/bin/bash

# Loki Stack Deployment Script
# Namespace: monitoring
# Components: Loki, Promtail, Prometheus, Grafana with Persistent Volumes

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
echo "========================================="
echo "Access Information"
echo "========================================="
echo ""

echo "==> Grafana Admin Password:"
echo "kubectl get secret -n $NAMESPACE $RELEASE_NAME-grafana -o jsonpath='{.data.admin-password}' | base64 --decode; echo"
echo ""

echo "==> Port-forward Grafana (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-grafana 3000:80"
echo "Then access: http://localhost:3000"
echo "Username: admin"
echo ""

echo "==> Port-forward Prometheus (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-kube-prometheus-prometheus 9090:9090"
echo "Then access: http://localhost:9090"
echo ""

echo "==> Port-forward Loki (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-loki-gateway 3100:80"
echo "Then access: http://localhost:3100"
echo ""

echo "==> Port-forward Alertmanager (run in separate terminal):"
echo "kubectl port-forward -n $NAMESPACE svc/$RELEASE_NAME-kube-prometheus-alertmanager 9093:9093"
echo "Then access: http://localhost:9093"
echo ""

echo "========================================="
echo "Useful Commands"
echo "========================================="
echo ""
echo "# View logs from Promtail:"
echo "kubectl logs -n $NAMESPACE -l app.kubernetes.io/name=promtail -f"
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