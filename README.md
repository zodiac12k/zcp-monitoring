# ZCP Monitoring Repo

## Monitoring Component 

| Component        | Version           | Image  |
| ------------- |-------------|-----|
|Grafana| 5.0.4 |grafana/grafana:5.0.4
|Prometheus|  2.2.1 |prom/prometheus:v2.2.1
|Alertmanager|  0.14.0  |prom/alertmanager:v0.14.0
|kube-state-metrics| 1.6.0 |k8s.gcr.io/kube-state-metrics:v1.6.0
|Node-Exporter| 0.15.2  |node-exporter:v0.15.2
|Blackbox-Exporter| 0.12.0  |prom/blackbox-exporter:v0.12.0
|ElasticSearch-Exporter| 1.0.2  |justwatch/elasticsearch_exporter:1.0.2

## Monitoring Dashboard(Grafana)

| Folder| Dashboard        | 
|------------- |-------------|
|System Dashboards|System Overview |Worker Node System Metric|
|                 |System Usage Overview|  
|                 |System DIsk Space|  
|Cluster Dashboards|Kubernetes: Cluster Overview |
|                  |Kubernetes: Resource Requests|
|                  |Kubernetes: Performance Overview|
|                  |Etcd Cluster|
|Container Dashboards|Kubernetes: POD Overview|
|                    |Kubernetes: Deployment Overview|
|                    |Kubernetes: DaemonSet Overview|
|                    |Kubernetes: StatefulSet Overview|
|Addon Dashboards|ElasticSearch|
|                |ZCP Service Status|

## Clone this git repository
```
$ git clone https://github.com/cnpst/zcp-monitoring.git
```

## Get IKS Deploy Env 

Monitoring 용도 ETCD TLS Secret 생성
```
# kubectl clent version 1.11 or higher, run the following command
$ kubectl patch secret calico-etcd-secrets -n kube-system -p='{"metadata": {"name": "etcd-secrets", "namespace": "zcp-system"}}' --dry-run -o yaml | kubectl create -f -
# kubectl clent version 1.10 or lower, run the following command
$ kubectl get secret calico-etcd-secrets -n kube-system -o yaml | sed 's/\(name\):.*$/\1: etcd-secrets/' | sed 's/\(namespace\):.*$/\1: zcp-system/' | kubectl create -f -
$ kubectl get secret -n zcp-system
NAME           TYPE     DATA
etcd-secrets   Opaque   3   
```

## Prometheus

### prometheus configmap 설정 및 생성

외부에서 식별 가능한 Cluster Name 변경하고 configmap 생성

```
$ cluster_name=$(kubectl config current-context | tr '[:lower:]' '[:upper:]')
$ cat prometheus/prometheus-cm.yaml | sed 's/CLOUDZCP-EXAMPLE-DEV/'$cluster_name'/' | kubectl create -f -
```

정상적으로 생성되었는지 확인
```
$ kubectl get cm -n zcp-system
NAME              DATA
prometheus-config 1   
$ kubectl get cm -n zcp-system prometheus-config -o yaml
...
data:
  prometheus.yml: |-
    global:
      scrape_interval: 15s
      scrape_timeout: 15s
      evaluation_interval: 15s
      external_labels:
        env: 'CLOUDZCP-EXAMPLE-DEV'
...
```

### (Optional) Persistent Volume 설정 및 생성

필요할 경우 storage-class, billingType, storage 용량 등 설정 변경
아래는 Block Storage 기준 기본값
```
$ cat prometheus/prometheus-pvc.yaml
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
      storage: 100Gi
```

### (Optional) Prometheus 환경 정보 설정

필요할 경우 tsdb metric 저장 유지 기간 설정 변경 (--storage.tsdb.retention)
```
$ vi prometheus/prometheus-deployment.yaml
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
```
### Deploy prometheus resources

```
$ kubectl create -f prometheus
```

## Prometheus exporters
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
  * [Go to the installation guide](exporters/elasticsearch-exporter/README.md)

## Alertmanager

### Deploy alertmanager resources
```
$ kubectl create -f alertmanager
```

## Grafana

### grafana 설정

monitoring domain name 과 keycloak iam 인증을 위한 url 변경 적용하기 위해 configmap 설정 변경
```
$ environment=$(kubectl config current-context | cut -d'-' -f3)
$ host_prefix=$(kubectl config current-context | if [ $environment = "dev" ];then cut -d'-' -f2,3;else cut -d'-' -f2;fi)
$ cat grafana/grafana-cm.yaml | sed 's/example/'${host_prefix}'/' | kubectl create -f -
...
```

정상적으로 생성되었는지 확인
```
$ kubectl get cm -n zcp-system
NAME                      DATA
monitoring-grafana-config 1   
$ kubectl get cm -n zcp-system monitoring-grafana-config -o yaml
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

### Deploy grafana resources

```
$ kubectl create -f grafana
```

## Ingress 생성 및 Monitoring 서비스 접속 확인

Ingress host 정보 내 Domain 정보 변경 및 생성
```
$ environment=$(kubectl config current-context | cut -d'-' -f3)
$ host_prefix=$(kubectl config current-context | if [ environment = "dev" ];then cut -d'-' -f2,3;else cut -d'-' -f2;fi)
$ alb_id=$(kubectl get deployment -n kube-system --no-headers=true -o=custom-columns=NAME:.metadata.name | grep "private-.*-alb")
$ cat ingress.yaml | sed 's/example/'${host_prefix}'/' | sed 's/\(ingress\.bluemix\.net\/ALB-ID\):.*$/\1: '${alb_id}'/' | kubectl create -f -
```
