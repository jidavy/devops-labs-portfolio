#!/bin/bash
# Tier 2 backend: Python 3 (FastAPI :9000) + Java 17 (Spring Boot :8080)
export HOME=/root
dnf install -y git python3 python3-pip java-17-amazon-corretto maven
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git
cd /opt/fruits-veg_market/python
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
nohup uvicorn main:app --host 0.0.0.0 --port 9000 > /var/log/fruits.log 2>&1 &
cd /opt/fruits-veg_market/java
nohup mvn spring-boot:run -Dspring-boot.run.arguments="--server.address=0.0.0.0 --server.port=8080" > /var/log/vegetables.log 2>&1 &
