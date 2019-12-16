# ZCP Helm Repo ADD

```
$ helm repo add zcp https://cnpst.github.io/charts

$ helm repo list
NAME        URL
...
zcp         https://cnpst.github.io/charts

$ helm search elasticsearch-exporter
NAME                            CHART VERSION   APP VERSION DESCRIPTION           
zcp/elasticsearch-exporter      0.1.1           1.0.2       Elasticsearch stats exporter for Prometheus
```
# Deploy 
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
 
```
$ helm install zcp/elasticsearch-exporter --name zcp-logging --namespace zcp-system --set es.uri=http://elasticsearch.zcp-system:9200,service.scrape=true,image.repository=registry.au-syd.bluemix.net/cloudzcp/elasticsearch_exporter,image.tag=1.0.2,tolerations.enabled=true
```

# Configuration

The following table lists the configurable parameters of the Elasticsearch-Exporter chart and their default values.

Parameter | Description | Default
--- | --- | ---
`replicaCount` | desired number of pods | `1`
`restartPolicy` | container restart policy | `Always`
`image.repository` | container image repository | `justwatch/elasticsearch_exporter`
`image.tag` | container image tag | `1.0.2`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`resources` | resource requests & limits | `{}`
`service.type` | type of service to create | `ClusterIP`
`service.httpPort` | port for the http service | `9108`
`es.uri` | address of the Elasticsearch node to connect to | `localhost:9200`
`es.all` | if `true`, query stats for all nodes in the cluster, rather than just the node we connect to | `true`
`es.indices` | if true, query stats for all indices in the cluster | `true`
`es.timeout` | timeout for trying to get stats from Elasticsearch | `30s`
`es.ssl.enabled` | If true, a secure connection to E cluster is used | `false`
`es.ssl.client.ca.pem` | PEM that contains trusted CAs used for setting up secure Elasticsearch connection |
`es.ssl.client.pem` | PEM that contains the client cert to connect to Elasticsearch |
`es.ssl.client.key` | Private key for client auth when connecting to Elasticsearch |
`web.path` | path under which to expose metrics | `/metrics`



