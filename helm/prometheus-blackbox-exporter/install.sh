#!/bin/bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i prometheus-blackbox-exporter prometheus-community/prometheus-blackbox-exporter \
--version 4.10.1 \
--namespace monitoring \
-f values-common.yaml \
