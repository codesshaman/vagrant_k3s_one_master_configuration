#!/bin/bash

echo "[K3S] : installing..."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 "
curl -sfL https://get.k3s.io |  sh -

echo "[K3S] : Copy naster-node-token to (/vagrant/scripts/node-token)"
# copy the master node token outside to the shared folder so workers node can connect to it
sudo cp /var/lib/rancher/k3s/server/node-token /mnt/token

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

echo "[machine : $(hostname)] has been setup succefully!"