# Loki Stack Helm Chart

[![GitHub Repo](https://img.shields.io/github/stars/Rishang/helm-chart)](https://github.com/Rishang/helm-chart)

Observability stack - Loki for logs, Grafana for visualization, Prometheus for metrics, and Grafana Alloy for log collection (alternative to deprecated Promtail).

## Overview

This Helm chart deploys a complete observability stack on Kubernetes, providing:

- **Loki**: Log aggregation system for storing and querying logs
- **Grafana**: Visualization and dashboards for logs and metrics
- **Prometheus**: Metrics collection and monitoring via kube-prometheus-stack
- **Grafana Alloy**: Modern log collection agent (replaces deprecated Promtail)

## Prerequisites

- Kubernetes 1.22+
- Helm 3.0+
- Persistent storage (optional, but recommended for production)

## Installation

### Add the repository (if applicable)

```bash
helm repo add <your-repo-name> <your-repo-url>
helm repo update
```

### Install the chart

```bash
helm install loki-stack . --namespace monitoring --create-namespace
```

### Install with custom values

```bash
helm install loki-stack . --namespace monitoring --create-namespace --values custom-values.yaml
```

## Configuration

### Key Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `loki.enabled` | Enable Loki log aggregation | `true` |
| `loki.deploymentMode` | Loki deployment mode | `SingleBinary` |
| `loki.singleBinary.persistence.enabled` | Enable persistent storage for Loki | `false` |
| `alloy.enabled` | Enable Grafana Alloy log collector | `true` |
| `kube-prometheus-stack.enabled` | Enable Prometheus and Grafana | `true` |
| `kube-prometheus-stack.grafana.enabled` | Enable Grafana dashboard | `true` |

### Example: Enable Persistence

```yaml
loki:
  singleBinary:
    persistence:
      enabled: true
      size: 10Gi
      storageClass: standard
```

### Example: Disable Components

```yaml
# Disable Prometheus stack, keep only Loki and Alloy
kube-prometheus-stack:
  enabled: false
```

## Accessing Services

### Grafana Dashboard

Port-forward to access Grafana:

```bash
kubectl port-forward -n monitoring svc/loki-stack-grafana 3000:80
```

Default credentials:
- Username: `admin`
- Password: Run `kubectl get secret -n monitoring loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode`

### Loki Query API

Port-forward to access Loki directly:

```bash
kubectl port-forward -n monitoring svc/loki-stack-loki 3100:3100
```

Query logs: `http://localhost:3100/loki/api/v1/query`

## Architecture

This chart deploys:

1. **Loki (SingleBinary mode)**: Stores and indexes logs
2. **Grafana Alloy (DaemonSet)**: Collects logs from `/var/log/pods` on each node
3. **Grafana**: Provides UI for log exploration and visualization
4. **Prometheus**: Collects metrics from Kubernetes and applications
5. **Alertmanager**: Handles alerts from Prometheus

## Log Collection

Grafana Alloy is configured to:
- Mount `/var/log` from each node
- Discover and tail logs from `/var/log/pods/*/*/*.log`
- Parse Kubernetes metadata (namespace, pod, container)
- Forward logs to Loki with proper labels

## Upgrading

```bash
helm upgrade loki-stack . --namespace monitoring --values custom-values.yaml
```

## Uninstallation

```bash
helm uninstall loki-stack --namespace monitoring
```

**Note**: PersistentVolumeClaims are not automatically deleted. Remove them manually if needed:

```bash
kubectl delete pvc -n monitoring -l app.kubernetes.io/instance=loki-stack
```

## Testing

Generate manifest for validation:

```bash
helm template loki-stack . --namespace monitoring --values test/values.yaml > loki-stack-manifest.yaml
```

## Dependencies

This chart depends on:

- [Loki](https://github.com/grafana/loki) 
- [Grafana Alloy](https://github.com/grafana/alloy) 
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts)

## Support

For issues and questions:
- Chart Issues: [GitHub Issues](https://github.com/your-org/helm-chart/issues)
- Loki Documentation: https://grafana.com/docs/loki/
- Alloy Documentation: https://grafana.com/docs/alloy/
