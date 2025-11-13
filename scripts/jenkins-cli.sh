#!/bin/bash

# Jenkins CLI Helper Script
# Usage: ./scripts/jenkins-cli.sh <command> [args...]

set -e

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JENKINS_USER="${JENKINS_USER:-admin}"
JENKINS_PASSWORD="${JENKINS_PASSWORD:-}"
JENKINS_CLI_JAR="${JENKINS_CLI_JAR:-./jenkins-cli.jar}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

download_cli() {
    if [ ! -f "$JENKINS_CLI_JAR" ]; then
        echo -e "${YELLOW}Downloading Jenkins CLI...${NC}"
        curl -o "$JENKINS_CLI_JAR" "$JENKINS_URL/jnlpJars/jenkins-cli.jar"
        echo -e "${GREEN}Jenkins CLI downloaded${NC}"
    fi
}

get_password() {
    if [ -z "$JENKINS_PASSWORD" ]; then
        echo -e "${YELLOW}Getting Jenkins admin password...${NC}"
        JENKINS_PASSWORD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "")
        if [ -z "$JENKINS_PASSWORD" ]; then
            echo -e "${RED}Could not retrieve password. Please set JENKINS_PASSWORD environment variable.${NC}"
            exit 1
        fi
    fi
}

run_cli() {
    download_cli
    get_password
    
    java -jar "$JENKINS_CLI_JAR" \
        -s "$JENKINS_URL" \
        -auth "$JENKINS_USER:$JENKINS_PASSWORD" \
        "$@"
}

show_help() {
    cat << EOF
Jenkins CLI Helper

Usage:
  ./scripts/jenkins-cli.sh <command> [args...]

Environment Variables:
  JENKINS_URL      Jenkins URL (default: http://localhost:8080)
  JENKINS_USER     Jenkins username (default: admin)
  JENKINS_PASSWORD Jenkins password (auto-retrieved if not set)
  JENKINS_CLI_JAR  Path to CLI jar (default: ./jenkins-cli.jar)

Common Commands:
  list-jobs                    List all jobs
  get-job <job-name>           Get job configuration
  create-job <job-name> <xml>  Create a new job
  build <job-name>             Trigger a build
  console <job-name> <build>   Get build console output
  version                      Show Jenkins version
  help                         Show this help

Examples:
  ./scripts/jenkins-cli.sh list-jobs
  ./scripts/jenkins-cli.sh build jenkins-lab
  ./scripts/jenkins-cli.sh console jenkins-lab 1
  ./scripts/jenkins-cli.sh version

For full CLI documentation:
  ./scripts/jenkins-cli.sh help

EOF
}

if [ $# -eq 0 ] || [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

run_cli "$@"

