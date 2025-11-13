#!/bin/bash

# Jenkins Setup Script
# This script helps set up Jenkins using Docker

set -e

JENKINS_HOME="${JENKINS_HOME:-./jenkins_home}"
JENKINS_PORT="${JENKINS_PORT:-8080}"

echo "Setting up Jenkins..."

mkdir -p "$JENKINS_HOME"
chmod 777 "$JENKINS_HOME"

echo "Starting Jenkins container on port $JENKINS_PORT..."
docker run -d \
  --name jenkins \
  -p $JENKINS_PORT:8080 \
  -p 50000:50000 \
  -v "$JENKINS_HOME":/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

echo "Jenkins container started!"
echo ""
echo "Waiting for Jenkins to initialize..."
sleep 10

# Get initial admin password
echo ""
echo "Initial Admin Password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || \
  echo "   Password will be available in a few moments. Run: ./scripts/jenkins-password.sh"

echo ""
echo "Jenkins is available at: http://localhost:$JENKINS_PORT"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:$JENKINS_PORT in your browser"
echo "2. Enter the initial admin password (see above)"
echo "3. Install suggested plugins"
echo "4. Create an admin user"
echo ""
echo "Useful commands:"
echo "  Stop Jenkins:    docker stop jenkins"
echo "  Start Jenkins:   docker start jenkins"
echo "  View logs:       docker logs -f jenkins"
echo "  Get password:    ./scripts/jenkins-password.sh"

