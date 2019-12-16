# Add the helm repository

```
$ helm repo add prometheus-process-exporter-charts https://raw.githubusercontent.com/mumoshu/prometheus-process-exporter/master/docs

$ helm repo list
NAME                              	URL
...
prometheus-process-exporter-charts	https://raw.githubusercontent.com/mumoshu/prometheus-process-exporter/master/docs

$ helm search process-exporter
NAME                                              	CHART VERSION	APP VERSION	DESCRIPTION
prometheus-process-exporter-charts/prometheus-p...	0.2.2        	0.4.0      	A Helm chart for prometheus process-exporter
```
# Deploy 
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
 
```
$ helm install --name process-exporter --namespace zcp-system prometheus-process-exporter-charts/prometheus-process-exporter -f values-zcp.yaml
$ helm install --name zcp-logging zcp/elasticsearch-exporter --set es.uri=http://elasticsearch.zcp-system:9200,service.scrape=true,image.repository=registry.au-syd.bluemix.net/cloudzcp/elasticsearch_exporter,image.tag=1.0.2
$ helm status process-exporter
```

# Reference

https://github.com/ncabatoff/process-exporter


