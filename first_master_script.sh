echo "installing RKE2. If this fails check your repos that are enabled"
curl -sfL https://get.rke2.io |  INSTALL_RKE2_VERSION="v1.25.16+rke2r1" sh -
echo "enabling the rke2 service"
systemctl enable rke2-server
echo "setting up the rke2 config.yaml"
mkdir -p /etc/rancher/rke2
echo "token: ${1}" > /etc/rancher/rke2/config.yaml
echo "selinux: true" >> /etc/rancher/rke2/config.yaml
echo "setting up kubectl"
echo 'PATH=${PATH}:/var/lib/rancher/rke2/bin' >> ~/.bashrc
mkdir ~/.kube
echo "starting rke2 service"
systemctl start rke2-server
echo "setting up helm"
cat /etc/rancher/rke2/rke2.yaml > ~/.kube/config
chmod 600 ~/.kube/config
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash