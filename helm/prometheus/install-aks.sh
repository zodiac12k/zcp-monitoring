#!/bin/bash

CLUSTER=cloudzcp-control-stg

ALERTMANAGER_ENABLED=true
ALERTMANAGER_BASEURL=https://alertmanager.skt.cloudzcp.com
ALERTMANAGER_INGRESS_CLASS=public-nginx
ALERTMANAGER_INGRESS_HOST=alertmanager.skt.cloudzcp.com
ALERTMANAGER_INGRESS_TLS_HOST=alertmanager.skt.cloudzcp.com
ALERTMANAGER_INGRESS_SECRET_NAME=skt-cloudzcp-com-cert

PROMETHEUS_INGRESS_CLASS=public-nginx
PROMETHEUS_INGRESS_HOST=prometheus.skt.cloudzcp.com
PROMETHEUS_INGRESS_TLS_HOST=prometheus.skt.cloudzcp.com
PROMETHEUS_INGRESS_SECRET_NAME=skt-cloudzcp-com-cert
PROMETHEUS_STORAGE_SIZE=100Gi
PROMETHEUS_STORAGE_CLASS=file-standard

kubectl apply -n monitoring -k .

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i prometheus prometheus-community/prometheus \
--version 13.0.0 \
--namespace monitoring \
-f values-common.yaml,values-rules.yaml,values-scrape-configs.yaml \
--set alertmanager.enabled=${ALERTMANAGER_ENABLED} \
--set alertmanager.baseURL=${ALERTMANAGER_BASEURL} \
--set alertmanager.ingress.enabled=true \
--set alertmanager.ingress.annotations."kubernetes\.io/ingress\.class"=${ALERTMANAGER_INGRESS_CLASS} \
--set-string alertmanager.ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-redirect"=true \
--set alertmanager.ingress.hosts[0]=${ALERTMANAGER_INGRESS_HOST} \
--set alertmanager.ingress.tls[0].hosts[0]=${ALERTMANAGER_INGRESS_TLS_HOST} \
--set alertmanager.ingress.tls[0].secretName=${ALERTMANAGER_INGRESS_SECRET_NAME} \
--set server.global.external_labels.cluster=${CLUSTER} \
--set server.ingress.enabled=true \
--set server.ingress.annotations."kubernetes\.io/ingress\.class"=${PROMETHEUS_INGRESS_CLASS} \
--set-string server.ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-redirect"=true \
--set server.ingress.hosts[0]=${PROMETHEUS_INGRESS_HOST} \
--set server.ingress.tls[0].hosts[0]=${PROMETHEUS_INGRESS_TLS_HOST} \
--set server.ingress.tls[0].secretName=${PROMETHEUS_INGRESS_SECRET_NAME} \
--set server.persistentVolume.size=${PROMETHEUS_STORAGE_SIZE} \
--set server.persistentVolume.storageClass=${PROMETHEUS_STORAGE_CLASS} \
#--set-file serverFiles."alerting_rules\.yml"=rules/prometheus.rules \