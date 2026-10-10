#!/bin/bash
# Tier 1 frontend: Nginx serving index.html
BACKEND_IP="REPLACE_WITH_BACKEND_PUBLIC_IP"
dnf install -y nginx git
systemctl enable --now nginx
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git
cp /opt/fruits-veg_market/web/index.html /usr/share/nginx/html/index.html
sed -i "s/FRUIT_MACHINE/${BACKEND_IP}/; s/VEG_MACHINE/${BACKEND_IP}/" /usr/share/nginx/html/index.html
