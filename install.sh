#!/bin/bash

# Create ectd secret
kubectl patch secret calico-etcd-secrets -n kube-system -p='{"metadata": {"name": "etcd-secrets", "namespace": "zcp-system"}}' --dry-run -o yaml | kubectl create -f -

# Clone kustomize overlays
git clone https://pog-dev-gitea.cloudzcp.io/cloudzcp-admin/zcp-monitoring-overlays

# Export cluster name for iks
current_context=$(kubectl config current-context)
export cluster_name=${current_context%%/*}
export CLUSTER_NAME=$(echo $cluster_name | tr '[:lower:]' '[:upper:]')
export host_prefix=$(if [ ${cluster_name##*-} = "dev" ]; then echo ${cluster_name#*-}; else remainder=${cluster_name#*-}; echo ${remainder%-*}; fi)
export alb_id=$(kubectl get deployment -n kube-system --no-headers=true -o=custom-columns=NAME:.metadata.name | grep "private-.*-alb")

# Create kustomize overlay
cp -r zcp-monitoring-overlays/template zcp-monitoring-overlays/${cluster_name}

# Update ingress and config files
sed -i '' 's/CLOUDZCP-TEMPLATE/'${CLUSTER_NAME}'/g' zcp-monitoring-overlays/$cluster_name/prometheus/config/prometheus.yml
sed -i '' 's/tpl/'${host_prefix}'/g' zcp-monitoring-overlays/$cluster_name/grafana/config/grafana.ini
sed -i '' 's/tpl/'${host_prefix}'/g' zcp-monitoring-overlays/$cluster_name/ingress_patch.yaml

# Add ingress annotation
cat >> zcp-monitoring-overlays/$cluster_name/ingress_patch.yaml <<EOF
- op: add
  path: /metadata/annotations
  value:
    ingress.bluemix.net/redirect-to-https: 'True'
    ingress.bluemix.net/ALB-ID: $alb_id
EOF

# Apply kustomize resources
kubectl apply -k zcp-monitoring-overlays/${cluster_name}