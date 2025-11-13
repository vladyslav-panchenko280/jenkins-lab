#!/bin/bash

CONTAINER_NAME="${JENKINS_CONTAINER:-jenkins}"

if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Jenkins Initial Admin Password:"
    echo ""
    docker exec $CONTAINER_NAME cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || \
        echo "Password file not found. Jenkins may still be initializing."
else
    echo "Jenkins container '$CONTAINER_NAME' is not running."
    echo "   Start Jenkins with: ./scripts/jenkins-setup.sh"
    exit 1
fi

