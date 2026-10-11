#!/bin/bash
# Week 4, Node 1: Nginx serving index.html, pointed at the two backend nodes
PYTHON_IP="REPLACE_WITH_PYTHON_NODE_IP"
JAVA_IP="REPLACE_WITH_JAVA_NODE_IP"
dnf install -y nginx git
systemctl enable --now nginx
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git
cp /opt/fruits-veg_market/web/index.html /usr/share/nginx/html/index.html
sed -i "s/FRUIT_MACHINE:9000/${PYTHON_IP}:9090/; s/VEG_MACHINE:8080/${JAVA_IP}:9998/" /usr/share/nginx/html/index.html
