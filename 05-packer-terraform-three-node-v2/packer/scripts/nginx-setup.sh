#!/bin/bash
set -e                                   # stop immediately if any command fails
dnf install -y nginx git
systemctl enable nginx                   # start on boot (not "--now": no need to start during the build)
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git
cp /opt/fruits-veg_market/web/index.html /usr/share/nginx/html/index.html
# NOTE: we do NOT run sed here. The backend IPs don't exist yet.
# Terraform will run sed at launch, once it knows the real IPs.