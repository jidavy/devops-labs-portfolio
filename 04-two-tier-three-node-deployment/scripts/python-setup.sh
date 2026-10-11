#!/bin/bash
# Week 4, Node 2: Python 3 (FastAPI) on port 9090
dnf install -y git python3 python3-pip
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git
cd /opt/fruits-veg_market/python
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
nohup uvicorn main:app --host 0.0.0.0 --port 9090 > /var/log/fruits.log 2>&1 &
