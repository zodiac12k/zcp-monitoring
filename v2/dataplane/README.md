# Cloud Z CP Monitoring component for dataplane cluster

## Component summary

| Component          | Chart Version | App Version | Image
| ---                | ---           | ---         | ---
| prometheus         | 11.6.0        | 2.19.0      | prom/prometheus:v2.19.0
| node-exporter      | 11.6.0        | 1.0.1       | prom/node-exporter:v1.0.1
| blackbox-exporter  | 4.1.1         | 0.16.0      | prom/blackbox-exporter:v0.16.0
| kube-state-metrics | 2.8.11        | 1.9.7       | quay.io/coreos/kube-state-metrics:v1.9.7

## Installation

> Installing and provisioning these components to dataplane cluster will be implemented as monitoring backend service.
> You will be able to meet this feature in the next official release of the Cloud Z CP v2.
> This installation guide focuses on example scripts.
> You need to change the variables according to your environment.

### Prerequisite

* Helm 3

### Prometheus for realm tenant of dataplane cluster

```shell script
helm install zcp-prometheus stable/prometheus -f prometheus/values-for-realm.yaml \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJza2NjIn0.Yh7te2ZzIPSxEBqNq6k1_PMdk851vttqhsrvdjnrrPJblQSaNnrxqbAYySkYaZC1LmDBGR0N9fcyVsfyt2weug \
--set server.ingress.hosts[0]=prometheus.eks-dev.cloudzcp.com \
--set server.ingress.tls[0].secretName=eks-dev-cloudzcp-com-cert \
--set server.ingress.tls[0].hosts[0]=prometheus-realm.eks-dev.cloudzcp.com
```

```shell script
helm upgrade zcp-prometheus stable/prometheus -f prometheus/values-for-realm.yaml \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJza2NjIn0.Yh7te2ZzIPSxEBqNq6k1_PMdk851vttqhsrvdjnrrPJblQSaNnrxqbAYySkYaZC1LmDBGR0N9fcyVsfyt2weug \
--set server.ingress.hosts[0]=prometheus.eks-dev.cloudzcp.com \
--set server.ingress.tls[0].secretName=eks-dev-cloudzcp-com-cert \
--set server.ingress.tls[0].hosts[0]=prometheus-realm.eks-dev.cloudzcp.com
```

### prometheus-blackbox-exporter for realm tenant of dataplane cluster

```shell script
helm install zcp-prometheus-blackbox-exporter stable/prometheus-blackbox-exporter -f prometheus-blackbox-exporter/values-for-realm.yaml \
--namespace zcp-system
```

```shell script
helm upgrade zcp-prometheus-blackbox-exporter stable/prometheus-blackbox-exporter -f prometheus-blackbox-exporter/values-for-realm.yaml \
--namespace zcp-system
```

### Prometheus for project tenant of dataplane cluster

```shell script
helm install t1-prometheus stable/prometheus -f prometheus/values-for-project.yaml \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJ0MSJ9.i4xQU9mrSKxAqDiIP7iS2vJjMAQo02NpVCXqWd0IceQPRFHYX86Xrsz8QnTFa_SQJoYUt17ay7GegMptbbZH0w
```

### kube-state-metrics for namespace of dataplane cluster

```shell script
helm install ns-a-kube-state-metrics stable/kube-state-metrics -f kube-state-metrics/values.yaml \
--namespace ns-a \
--set namespace=ns-a
```

```shell script
helm install cicd-1-kube-state-metrics stable/kube-state-metrics -f kube-state-metrics/values.yaml \
--namespace ns-b \
--set namespace=ns-b
```