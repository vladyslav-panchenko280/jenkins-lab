#!/bin/bash

# Jenkins Status Script
# Shows Jenkins status and information

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
CONTAINER_NAME="${JENKINS_CONTAINER:-jenkins}"

echo "Jenkins Status"

if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Jenkins container is running"
    
    echo "Container Information:"
    docker ps --filter "name=$CONTAINER_NAME" --format "  Name: {{.Names}}\n  Status: {{.Status}}\n  Ports: {{.Ports}}"
    
    if curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL" | grep -q "200\|403"; then
        echo "✅ Jenkins is responding at $JENKINS_URL"
        
        echo "Jenkins Version:"
        ./scripts/jenkins-cli.sh version 2>/dev/null || echo "  (Unable to retrieve version)"
        
        echo ""
        echo "Jobs:"
        ./scripts/jenkins-cli.sh list-jobs 2>/dev/null | sed 's/^/  - /' || echo "  (Unable to list jobs)"
    else
        echo "Jenkins is not responding at $JENKINS_URL"
        echo "   It may still be initializing..."
    fi
else
    echo "Jenkins container '$CONTAINER_NAME' is not running"
    echo ""
    echo "Start Jenkins with:"
    echo "  ./scripts/jenkins-setup.sh"
    echo "  or"
    echo "  docker-compose up -d"
fi


