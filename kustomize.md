## Develop with kustomize

```
kustomize edit add resource exporters/blackbox-exporter/**
kustomize edit add resource exporters/kube-state-metrics/**
kustomize edit add resource exporters/node-exporter/**
kustomize edit add resource prometheus/**
kustomize edit add resource alertmanager/**
kustomize edit add resource grafana/**

kustomize edit add configmap prometheus-rules --from-file='prometheus/rules/*.rules'
kustomize edit add configmap prometheus-config --from-file='prometheus/config/prometheus.yml'
kustomize edit add configmap alertmanager --from-file='alertmanager/config/config.yml'
kustomize edit add configmap monitoring-grafana-config --from-file='grafana/config/grafana.ini'
kustomize edit add configmap monitoring-grafana-dashboard-addon --from-file='grafana/dashboard/addon/*.json'
kustomize edit add configmap monitoring-grafana-dashboard-cluster --from-file='grafana/dashboard/cluster/*.json'
kustomize edit add configmap monitoring-grafana-dashboard-container --from-file='grafana/dashboard/container/*.json'
kustomize edit add configmap monitoring-grafana-dashboard-system --from-file='grafana/dashboard/system/*.json'
```

## Build with kustomize

```
kustomize build .
```