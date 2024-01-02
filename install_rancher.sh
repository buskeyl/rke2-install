echo "adding helm repo"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
echo "creating cattle system namespace"
kubectl create namespace cattle-system

# Rancher Install Docs
# https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster

# CertManager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.3 --set installCRDs=true

# BYO Certs
# https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/add-tls-secrets

echo "installing Rancher If certmanager is already installed"
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org --set bootstrapPassword=admin 

Echo "watching the Rancher rollout"
kubectl -n cattle-system rollout status deploy/rancher
