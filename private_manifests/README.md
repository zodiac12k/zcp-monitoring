# ZCP Monitoring Repo

## Monitoring Component 

| Component        | Version           | Image  |
| ------------- |-------------|-----|
|Grafana| 5.0.4 |grafana/grafana:5.0.4
|Prometheus|  2.2.1 |prom/prometheus:v2.2.1
|Alertmanager|  0.14.0  |prom/alertmanager:v0.14.0
|kube-state-metric| 1.3.0 |k8s.gcr.io/kube-state-metrics:v1.3.0
|Node-Exporter| 0.15.2  |node-exporter:v0.15.2
|Blackbox-Exporter| 0.12.0  |prom/blackbox-exporter:v0.12.0
|ElasticSearch-Exporter| 1.0.2  |justwatch/elasticsearch_exporter:1.0.2

## Monitoring Dashboard(Grafana)

| Folder| Dashboard        | 
|------------- |-------------|
|System Dashboards| System Overview |Worker Node System Metric 지표|
||System Usage Overview|  
||System DIsk Space|  
|Cluster Dashboards |Kubernetes: Cluster Overview |
||Kubernetes: Resource Requests|
||Kubernetes: Performance Overview|
||Etcd Cluster|
|Container Dashboards|Kubernetes: POD Overview  |
||Kubernetes: Deployment Overview|
||Kubernetes: DaemonSet Overview|
||Kubernetes: StatefulSet Overview|
|Addon Dashboards|ElasticSearch|
||ZCP Service Status|

## Get IKS Deploy Env 

* Monitoring 용도 ETCD TLS Secret 생성
```
$ kubectl patch secret calico-etcd-secrets -n kube-system -p='{"metadata": {"name": "etcd-secrets", "namespace": "zcp-system"}}' --dry-run -o yaml | kubectl create -f -
$ kubectl get secret
NAME           TYPE     DATA   AGE
etcd-secrets   Opaque   3      56s
```

* IKS Cluster Name 설정
외부에서 식별 가능한 Cluster Name 변경(env 설정)
```
$ vi private_manifests/prometheus/prometheus-cm.yaml
...
data:
  prometheus.yml: |-
    global:
      scrape_interval: 15s
      scrape_timeout: 15s
      evaluation_interval: 15s
      external_labels:
        env: 'CLOUDZCP-POU-DEV'
```

* Grafana 설정 변경
```
$ vi private_manifests/grafana/grafana-cm.yaml
...
    [server]
    protocol = http
    http_port = 3000
    domain = example-monitoring.cloudzcp.io
...
    [auth.generic_oauth]
    name = OAuth
    enabled = true
    allow_sign_up = true
    client_id = monitoring
    client_secret = 4138cbf9-4091-4029-a1d6-d64450994f55
    scopes = openid email name
    auth_url = https://example-iam.cloudzcp.io/auth/realms/zcp/protocol/openid-connect/auth
    token_url = https://example-iam.cloudzcp.io/auth/realms/zcp/protocol/openid-connect/token
...
```

## Prometheus Deploy

* Persistent Volume 설정 및 생성(File/Block Storage Option)

Storage-Class 설정 및 PV 생성 Option 변경(Block Storage 기준)
```
$ vi private_manifests/prometheus/prometheus-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
  namespace: zcp-system
  annotations:
    volume.beta.kubernetes.io/storage-class: "ibmc-block-retain-silver"
  labels:
    billingType: "hourly"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
```

* Prometheus 환경 정보 설정

Metric 유지 기간 설정 및 Prometheus external-url(Ingress Domain) 변경 (--storage.tsdb.retention, --web.external-url)
```
$ vi private_manifests/prometheus/prometheus-deployment.yaml
...
containers:
  - name: prometheus
    image: prom/prometheus:v2.2.1
    args:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus/"
      - "--storage.tsdb.retention=20d"
      - "--web.enable-lifecycle"
      - "--web.enable-admin-api"
      - "--web.external-url=http://prometheus.example.sk.com"
```
* Prometheus Deploy

```
$ kubectl create -f prometheus
```

## Exporter Deploy
* kube-state-metric
```
$ kubectl create -f exporters/kube-state-metric
```
* node-exporter
```
$ kubectl create -f exporters/node-exporter
```
* blackbox-exporter
```
$ kubectl create -f exporters/blackbox-exporter
```
* elasticsearch-exporter
  * assets/ElasticSearch-Exporter-Deploy.md

## Grafana Deploy
```
$ kubectl create -f grafana
```

## Alertmanager Deploy

* Alertmanager Deploy
```
$ kubectl create -f alertmanager
```

## Ingress 생성 및 Monitoring 서비스 접속 확인
Ingress host 정보 내 Domain 정보 수정 필요(example.sk.com)
```
$ cat ingress.yaml | sed 's/example/${host_prefix}/' | sed 's/\(ingress\.bluemix\.net\/ALB-ID\):.*$/\1: ${alb_id}/' | kubectl create -f -
$ cat ingress.yaml 
            apiVersion: extensions/v1beta1
            kind: Ingress
            metadata:
              name: monitoring-ingress
              namespace: zcp-system
            spec:
              rules:
              - host: example-monitoring.cloudzcp.io
                http:
                  paths:
                  - path: /
                    backend:
                      serviceName: grafana-service
                      servicePort: 3000
              tls:
                - secretName: cloudzcp-io-cert
                  hosts:
        - example-monitoring.cloudzcp.io

$ kubectl create -f ingress.yaml
```
