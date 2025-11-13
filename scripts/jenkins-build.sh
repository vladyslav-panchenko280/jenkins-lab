#!/bin/bash

# Trigger Jenkins Build Script
# Usage: ./scripts/jenkins-build.sh [job-name]

set -e

JOB_NAME="${1:-jenkins-lab}"
JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"

echo "Triggering build for job: $JOB_NAME"

./scripts/jenkins-cli.sh build "$JOB_NAME" -s

echo "Build triggered successfully!"
echo "   View build at: $JENKINS_URL/job/$JOB_NAME"

