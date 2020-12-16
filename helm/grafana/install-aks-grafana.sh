#!/bin/bash

GRAFANA_INGRESS_CLASS=public-nginx
GRAFANA_INGRESS_HOST=monitoring.skt.cloudzcp.com
GRAFANA_INGRESS_TLS_HOST=monitoring.skt.cloudzcp.com
GRAFANA_INGRESS_SECRET_NAME=skt-cloudzcp-com-cert
GRAFANA_SERVER_DOMAIN=monitoring.skt.cloudzcp.com
GRAFANA_AUTH_GENERIC_OAUTH_AUTH_URL=https://iam.skt.cloudzcp.com/auth/realms/zcp/protocol/openid-connect/auth
GRAFANA_ADMIN_PASSWORD=admin
GRAFANA_AUTH_GENERIC_OAUTH_CLIENT_SECRET=bc28a1aa-f409-4b91-ab21-b1fc8e579966
GRAFANA_AUTH_GENERIC_OAUTH_TOKEN_URL=http://keycloak-http.iam:80/auth/realms/zcp/protocol/openid-connect/token
GRAFANA_DATABASE_URL=postgres://grafana:grafana@monitoring-db-postgresql.monitoring:5432/grafana

helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade -i monitoring grafana/grafana \
--version 5.7.1 \
--namespace monitoring \
-f values-zcp.yaml,values-aks.yaml \
--set ingress.annotations."kubernetes\.io/ingress\.class"=${GRAFANA_INGRESS_CLASS} \
--set ingress.hosts[0]=${GRAFANA_INGRESS_HOST} \
--set ingress.tls[0].hosts[0]=${GRAFANA_INGRESS_TLS_HOST} \
--set ingress.tls[0].secretName=${GRAFANA_INGRESS_SECRET_NAME} \
--set env.GF_SERVER_DOMAIN=${GRAFANA_SERVER_DOMAIN} \
--set env.GF_AUTH_GENERIC_OAUTH_AUTH_URL=${GRAFANA_AUTH_GENERIC_OAUTH_AUTH_URL} \
--set adminPassword=${GRAFANA_ADMIN_PASSWORD} \
--set "grafana\.ini"."auth\.generic_oauth".client_secret=${GRAFANA_AUTH_GENERIC_OAUTH_CLIENT_SECRET} \
--set "grafana\.ini"."auth\.generic_oauth".token_url=${GRAFANA_AUTH_GENERIC_OAUTH_TOKEN_URL} \
--set "grafana\.ini".database.url=${GRAFANA_DATABASE_URL} \
