#!/bin/bash

echo "[K3S] : installing..."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 "
curl -sfL https://get.k3s.io |  sh -

echo "[K3S] : Copy naster-node-token to (/vagrant/scripts/node-token)"
# copy the master node token outside to the shared folder so workers node can connect to it
sudo cp /var/lib/rancher/k3s/server/node-token /mnt/token

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

source <(kubectl completion bash)

echo "source <(kubectl completion bash)" >> ~/.bashrc

echo "[machine : $(hostname)] has been setup succefully!"

# Install the metrics

sudo cp /mnt/node_exporter /usr/bin

sudo apt update && sudo apt install supervisor git
sudo systemctl status supervisor

{   echo '[program:node_exporter]'; \
    echo 'command=/usr/bin/node_exporter'; \
    echo 'autostart=true'; \
    echo 'autorestart=true'; \
    echo 'stderr_logfile=/var/log/node_exporter.err.log'; \
    echo 'stdout_logfile=/var/log/node_exporter.out.log'; \
} | tee  /etc/supervisor/conf.d/node_exporter_metrics.conf; \

sudo supervisorctl reread

echo "Node exporter has been setup succefully!"
