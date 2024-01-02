#!/bin/sh
echo "reccommend opening 2 shells before starting this script"

sleep 10

echo "adding helm repo"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
echo "creating cattle system namespace"
kubectl create namespace cattle-system

# Rancher Install Docs
# https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster

function selfsigned () {
    # CertManager
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.3 --set installCRDs=true

    echo "Waiting for Certmanager to deploy"
    sleep 60

    echo "installing Rancher If certmanager is already installed"
    helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org --set bootstrapPassword=admin 

    Echo "watching the Rancher rollout"
    kubectl -n cattle-system rollout status deploy/rancher

}

# BYO Certs .. 
# https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/add-tls-secrets

function byocerts () {
    read -p "Certfile Path" tlscrt
    read -p "Cert Keyfile" tlskey
    kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=${tlscrt} --key=${tlskey}
    
    read -p "Is this a cert signed by a privateCA? (y/n)" private

    if [ $private = 'n' ]; then
        echo "installing Rancher with a globally trusted cert"
        helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org --set ingress.tls.source=secret --set bootstrapPassword=admin 

        Echo "watching the Rancher rollout"
        kubectl -n cattle-system rollout status deploy/rancher
    else
        read -p "ca chain file path" cachainpath
        kubectl -n cattle-system create secret generic tls-ca --from-file=cacerts.pem=${cachainpath}
        echo "installing Rancher with a private CA cert"
        read -p "input rancher domain" rancherhostname
        helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=${rancherhostname} --set ingress.tls.source=secret bootstrapPassword=admin --set privateCA=true

        echo "watching the Rancher rollout"
        kubectl -n cattle-system rollout status deploy/rancher
    fi

}

read -p "Install Certmanager? If you have your own certs answer, no (y/n)" certmanager

if [ certmanager = 'y']; then 
    selfsigned
else 
    byocerts
fi

