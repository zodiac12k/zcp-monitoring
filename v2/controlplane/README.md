# Installation

## Prerequisite

* Helm 3

## Cortex

Data Centralization, Long Term Storage, Multi Tenancy for prometheus metrics

### Create S3 for cortex backend storage

### Install cortex with helm 3

Move to cortex helm chart repository
```shell script
helm install cortex . -f values-cortex.yaml
```

### Cortex gateway

```shell script
kubectl create secret generic cortex-jwt-secret --from-literal jwt_secret=xxx
```

```shell script
kubectl apply -f gateway-deployment.yaml
kubectl apply -f gateway-service.yaml
```

## Grafana

### Install postgresql for grafana db of controlplane cluster

```shell script
helm install zcp-monitoring-posgresql bitnami/postgresql \
--set persistence.storageClass=ebs-gp2
```

### Install grafana for controlplane cluster

```shell script
helm install zcp-monitoring stable/grafana --namespace zcp-system -f values.yaml \
--set ingress.ingress."kubernetes\.io/ingress\.class"=nginx \
--set ingress.hosts[0]=monitoring.mcm-dev.cloudzcp.com \
--set ingress.tls[0].secretName="cloudzcp-com-cert" \
--set ingress.tls[0].hosts[0]=monitoring.mcm-dev.cloudzcp.com \
--set persistence.storageClassName=efs-zcp \
--set persistence.size=5Gi \
--set env.GF_SERVER_DOMAIN=monitoring.mcm-dev.cloudzcp.com \
--set env.GF_AUTH_GENERIC_OAUTH_AUTH_URL=https://iam.mcm-dev.cloudzcp.com/auth/realms/zcp/protocol/openid-connect/auth \
--set "grafana\.ini".database.url=postgres://postgres:oA3TRh8PNr@zcp-monitoring-posgresql-postgresql:5432/grafana \
--set datasources."datasources\.yaml".datasources[0].jsonData.httpHeaderValue1="Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0ZW5hbnRfaWQiOiJza2NjIn0.Yh7te2ZzIPSxEBqNq6k1_PMdk851vttqhsrvdjnrrPJblQSaNnrxqbAYySkYaZC1LmDBGR0N9fcyVsfyt2weug"
```

