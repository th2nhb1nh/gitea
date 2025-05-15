#!/bin/bash

# Get your local network IP address
EXTERNAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
echo "External IP detected as: $EXTERNAL_IP"

# Export for docker-compose
export EXTERNAL_IP

# Start Gitea
docker-compose up -d

echo "Gitea is running at:"
echo "- Local web access: http://localhost:3000"
echo "- External web access: http://$EXTERNAL_IP:3000"
echo "- SSH access: ssh://git@$EXTERNAL_IP:2222"