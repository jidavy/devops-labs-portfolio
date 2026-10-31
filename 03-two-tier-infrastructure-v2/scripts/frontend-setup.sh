#!/bin/bash
dnf update -y

# Install nginx
dnf install nginx -y

# Start nginx service and Enable nginx to start on boot
systemctl enable --now nginx

# Create a simple welcome page
echo "<h1>Frontend Server - Tier 1 by Banzy</h1>" | sudo tee /usr/share/nginx/html/index.html

echo "Frontend setup complete!"
