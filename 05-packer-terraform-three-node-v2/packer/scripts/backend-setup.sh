#!/bin/bash
set -e
export HOME=/root                        # Maven needs a home directory when run as root
dnf install -y git java-17-amazon-corretto maven python3 python3-pip
cd /opt
git clone https://github.com/jidavy/fruits-veg_market.git

# Java: build the jar now so launching is fast
cd /opt/fruits-veg_market/java
mvn -q -DskipTests package
ls -l target/*.jar                       # prints the jar name in the build log so we can confirm it

# Python: create the virtual environment and install dependencies now
cd /opt/fruits-veg_market/python
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt