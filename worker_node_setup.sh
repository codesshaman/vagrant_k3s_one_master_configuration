#!/bin/bash

# add k3s master node ip and worker node ip
export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /mnt/token --node-ip=$2"

# download and run k3s agent
curl -sfL https://get.k3s.io | sh -

# Install the metrics

sudo cp /mnt/node_exporter /usr/bin

sudo apt update && sudo apt install supervisor
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