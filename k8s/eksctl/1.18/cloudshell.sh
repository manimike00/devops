#!/usr/bin/env bash

echo "[TASK 1] Create Local Binary Directory"
mkdir -p ~/.local/bin/

echo "[TASK 2] Install kubectl binary"
sudo curl -LO https://dl.k8s.io/release/v1.20.0/bin/linux/amd64/kubectl >/dev/null 2>&1
sudo chown $USER:$USER kubectl
sudo chown 0755 kubectl
sudo mv ./kubectl ~/.local/bin/

echo "[TASK 3] Install helm"
wget https://get.helm.sh/helm-v3.5.0-linux-amd64.tar.gz >/dev/null 2>&1
tar -zxf helm-v3.5.0-linux-amd64.tar.gz
mv linux-amd64/helm ~/.local/bin/
rm -rf linux-amd64 helm-v3.5.0-linux-amd64.tar.gz

echo "[TASK 4] Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ~/.local/bin/ >/dev/null 2>&1

echo "[TASK 5] Set Path"
export PATH=$PATH:~/.local/bin/