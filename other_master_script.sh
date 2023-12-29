echo "installing RKE2. If this fails check your repos that are enabled"
curl -sfL https://get.rke2.io |  INSTALL_RKE2_VERSION="v1.25.16+rke2r1" sh -
echo "enabling the rke2 service"
systemctl enable rke2-server
echo "setting up the rke2 config.yaml"
mkdir -p /etc/rancher/rke2
echo "server: https://${1}:9345" > /etc/rancher/rke2/config.yaml
echo "token: ${2}" >> /etc/rancher/rke2/config.yaml
echo "setting up the rke2 config.yaml"
echo "setting up helm"
systemctl start rke2-server