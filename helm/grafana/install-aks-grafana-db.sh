#!/bin/bash

POSTGRESQL_PASSWORD=grafana
PERSISTENCE_STORAGE_CLASS=managed-standard
PERSISTENCE_SIZE=8Gi

helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade -i monitoring-db bitnami/postgresql \
--version 9.3.2 \
--namespace monitoring \
-f postgresql/values-common.yaml \
--set postgresqlPassword=${POSTGRESQL_PASSWORD} \
--set persistence.storageClass=${PERSISTENCE_STORAGE_CLASS} \
--set persistence.size=${PERSISTENCE_SIZE} \
