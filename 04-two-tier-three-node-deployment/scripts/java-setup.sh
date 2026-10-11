#!/bin/bash
# Week 4, Node 3: Java 17 (Spring Boot) on port 9998
export HOME=/root
dnf install -y git java-17-amazon-corretto maven
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git
cd /opt/fruits-veg_market/java
nohup mvn spring-boot:run -Dspring-boot.run.arguments="--server.address=0.0.0.0 --server.port=9998" > /var/log/vegetables.log 2>&1 &
