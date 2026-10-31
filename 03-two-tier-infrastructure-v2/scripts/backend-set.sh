#!/bin/bash
dnf update -y

# Install Python 3
dnf install python3 -y

# Install Java 17
dnf install java-17-amazon-corretto-devel -y

echo "Backend setup complete!"
