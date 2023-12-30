echo "adding helm repo"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
echo "creating cattle system namespace"
kubectl create namespace cattle-system
echo "installing Rancher"
elm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org --set bootstrapPassword=admin --set global.cattle.psp.enabled=false
kubectl -n cattle-system rollout status deploy/rancher
