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
## Get ICCS Deploy Env 

* ETCD ENDPOINT 정보 확인(IP, Port)

```
$ kubectl -n kube-system exec -it calico-kube-controllers-86dc74b64-2lv9l env | grep ETCD_ENDPOINTS
ETCD_ENDPOINTS=https://[IP]:[Port]
```

* ETCD TLS Secret Export 
```
$ kubectl -n kube-system get secret calico-etcd-secrets -o yaml > etcd-secrets.yaml
```

* Monitoring 용도 ETCD TLS Secret 생성 (Namespace, ConfigMap Name 변경 필요)
```
$ vi etcd-secret.yaml
...
name: etcd-secrets
namespace: zcp-system

$ kubectl create -f etcd-secrets.yaml
$ kubectl get secret
NAME                             TYPE                                  DATA      AGE
etcd-secrets                     Opaque                                3         21d
```

* ETCD Metric 수집 설정
```
$ vi private_manifests/prometheus/prometheus-cm.yaml
...
- job_name: 'etcd'
  static_configs:
  - targets:
    - [ETCD_IP]:[ETCD_PORT]
  tls_config:
    ca_file: /etc/config/etcd-ca
    cert_file: /etc/config/etcd-cert
    key_file: /etc/config/etcd-key
    insecure_skip_verify: true
  scheme: https
```

* ICCS Cluste Name 설정
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
        env: 'SK-CPS-ICCS-K8S-DEV'
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
    volume.beta.kubernetes.io/storage-class: "ibmc-block-retain-bronze"
  labels:
    billingType: "monthly"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
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

## Grafana Deploy
```
$ kubectl create -f grafana
```

## Alertmanager Deploy
* Alertmanager 환경 정보 설정
Alert을 전송받을 Slack api uri 입력
```
$ vi private_manifests/alertmanager/alertmanager-config-cm.yaml
```
    - name: ‘sk-cps-ops’
      slack_configs:
      - api_url: #slack api uri
        send_resolved: true
```

* Alertmanager Deploy
```
$ kubectl create -f alertmanager
```

## Ingress 생성 및 Monitoring 서비스 접속 확인
Ingress host 정보 내 Domain 정보 수정 필요(example.sk.com)
```
$ cat ingress.yaml 
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: monitoring-ingress
  namespace: zcp-system
spec:
  rules:
  - host: cbt-monitoring.cloudzcp.io
    http:
      paths:
      - path: /
        backend:
          serviceName: grafana-service
          servicePort: 3000
  tls:
    - secretName: cloudzcp-io-cert
      hosts:
        - cbt-monitoring.cloudzcp.io

$ kubectl create -f ingress.yaml
```
