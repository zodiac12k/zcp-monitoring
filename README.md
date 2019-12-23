# Cloud Z CP Public Monitoring

## Monitoring Component

| Component        | Version           | Image  |
| ------------- |-------------|-----|
|Grafana| 5.0.4 |grafana/grafana:5.0.4
|Prometheus|  2.2.1 |prom/prometheus:v2.2.1
|Alertmanager|  0.14.0  |prom/alertmanager:v0.14.0
|kube-state-metrics| 1.6.0 |quay.io/coreos/kube-state-metrics:v1.6.0
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

## Installation

### Prerequisite

* kubectl client version 1.14 or higher

### Clone this git repository

```
$ git clone https://github.com/cnpst/zcp-monitoring.git
```

### Run the install script

### for IKS

```
$ ./install --provider iks
```

만약 public 접근이 필요하다면

```
$ ./install --provider iks --access public
```

### for EKS

```
$ ./install --provider eks
```

만약 public 접근이 필요하다면

```
$ ./install --provider eks --access public
```

### for AKS

```
$ ./install --provider aks
```

만약 public 접근이 필요하다면

```
$ ./install --provider aks --access public
```

### (Optional) Install elasticsearch exporter

elasticsearch exporter 는 Logging 컴포넌트를 구성할 경우에만 설치합니다.

* elasticsearch-exporter
  * [Go to the installation guide](helm/elasticsearch-exporter/README.md)

## How to use

[User guide](https://support.cloudz.co.kr/support/solutions/articles/42000042547-%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81-%EC%A1%B0%ED%9A%8C-cluster-admin-)