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

## Monitoring Dashboard(Grafana)

| Folder| Dashboard        | 
|------------- |-------------|
|System Dashboards| System Overview |Worker Node System Metric 지표|
||System Usage Overview|  
||System DIsk Space|  
|Cluster Dashboards |Kubernetes: Cluster Overview |
||Kubernetes: Resource Requests|
||Etcd Cluster|
|Container Dashboards|  POD Overview  |


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
namespace: monitoring

$ kubectl create -f etcd-secrets.yaml
$ kubectl get secret
NAME                             TYPE                                  DATA      AGE
etcd-secrets                     Opaque                                3         21d
```

* ETCD Metric 수집 설정
```
$ vi manifests/prometheus/prometheus-cm.yaml
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

## Prometheus Deploy

* Monitoring Namespace 생성
```
$ kubectl create -f namespace.yaml
```

* Persistent Volume 설정 및 생성(File/Block Storage Option)

Storage-Class 설정 및 PV 생성 Option 변경(Block Storage 기준)
```
$ vi manifests/prometheus/prometheus-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
  namespace: monitoring
  annotations:
    volume.beta.kubernetes.io/storage-class: "ibmc-block-retain-bronze"
  labels:
    billingType: "hourly"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```


* Prometheus Deploy

```
$ kubectl create -f manifests/prometheus/
```


## Exporter Deploy
* kube-state-metric
```
$ kubectl create -f repos/manifests/exporters/kube-state-metric
```
* node-exporter
```
$ kubectl create -f repos/manifests/exporters/node-exporter
```
* blackbox-exporter
```
$ kubectl create -f repos/manifests/exporters/blackbox-exporter
```

## Grafana Deploy
```
$ kubectl create -f repos/manifests/grafana
```

## Alertmanager Deploy
```
$ kubectl create -f repos/manifests/alertmanager
```

## Ingress 생성 및 Monitoring 서비스 접속 확인
Ingress host 정보 내 Domain 정보 수정 필요(example.sk.com)
```
$ cat ingress.yaml 
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: monitoring-ingress
  namespace: monitoring
spec:
  rules:
  - host: prometheus.example.sk.com
    http:
      paths:
      - path: /
        backend:
          serviceName: prometheus-service
          servicePort: 9090
  - host: grafana.example.sk.com
    http:
      paths:
      - path: /
        backend:
          serviceName: grafana-service
          servicePort: 3000
  - host: alertmanager.example.sk.com
    http:
      paths:
      - path: /
        backend:
          serviceName: alertmanager-service
          servicePort: 9093
  - host: blackbox.example.sk.com
    http:
      paths:
      - path: /
        backend:
          serviceName: blackbox
          servicePort: 9115

$ kubectl create -f repos/ingress.yaml
```
