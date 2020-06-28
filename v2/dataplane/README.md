# Install prometheus for realm tenant of dataplane cluster

```shell script
helm install zcp-prometheus stable/prometheus -f prometheus/values-for-realm.yaml \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJza2NjIn0.Yh7te2ZzIPSxEBqNq6k1_PMdk851vttqhsrvdjnrrPJblQSaNnrxqbAYySkYaZC1LmDBGR0N9fcyVsfyt2weug \
--set server.ingress.hosts[0]=prometheus-realm.eks-dev.cloudzcp.com \
--set server.ingress.tls[0].secretName=eks-dev-cloudzcp-com-cert \
--set server.ingress.tls[0].hosts[0]=prometheus-realm.eks-dev.cloudzcp.com
```

```shell script
helm upgrade zcp-prometheus stable/prometheus -f prometheus/values-for-realm.yaml \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJza2NjIn0.Yh7te2ZzIPSxEBqNq6k1_PMdk851vttqhsrvdjnrrPJblQSaNnrxqbAYySkYaZC1LmDBGR0N9fcyVsfyt2weug \
--set server.ingress.hosts[0]=prometheus-realm.eks-dev.cloudzcp.com \
--set server.ingress.tls[0].secretName=eks-dev-cloudzcp-com-cert \
--set server.ingress.tls[0].hosts[0]=prometheus-realm.eks-dev.cloudzcp.com
```

# Install prometheus-blackbox-exporter for realm tenant of dataplane cluster

```shell script
helm install zcp-prometheus-blackbox-exporter stable/prometheus-blackbox-exporter -f prometheus-blackbox-exporter/values-for-realm.yaml \
--namespace zcp-system
```

```shell script
helm upgrade zcp-prometheus-blackbox-exporter stable/prometheus-blackbox-exporter -f prometheus-blackbox-exporter/values-for-realm.yaml \
--namespace zcp-system
```

# Install prometheus for project tenant of dataplane cluster

```shell script
helm install t1-prometheus stable/prometheus -f prometheus/values-for-project.yaml \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJ0MSJ9.i4xQU9mrSKxAqDiIP7iS2vJjMAQo02NpVCXqWd0IceQPRFHYX86Xrsz8QnTFa_SQJoYUt17ay7GegMptbbZH0w
```

```shell script
helm upgrade zcp-prometheus stable/prometheus -f prometheus/values-for-realm.yaml \
--namespace zcp-system \
--namespace zcp-system \
--set server.global.external_labels.cluster=cloudzcp-eks-dev \
--set server.remoteWrite[0].url=https://cortex.mcm-dev.cloudzcp.com/api/prom/push \
--set server.remoteWrite[0].bearer_token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJ0MSJ9.i4xQU9mrSKxAqDiIP7iS2vJjMAQo02NpVCXqWd0IceQPRFHYX86Xrsz8QnTFa_SQJoYUt17ay7GegMptbbZH0w
```

# Install kube-state-metrics for namespace of dataplane cluster

```shell script
helm install ns-a-kube-state-metrics stable/kube-state-metrics -f kube-state-metrics/values.yaml \
--namespace ns-a \
--set namespace=ns-a
```

```shell script
helm install cicd-1-kube-state-metrics stable/kube-state-metrics -f kube-state-metrics/values.yaml \
--namespace cicd-1 \
--set namespace=cicd-1
```