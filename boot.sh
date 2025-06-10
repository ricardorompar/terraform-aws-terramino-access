#!/bin/bash
set -euo pipefail

LOGFILE="/var/log/terramino-cloud-init.log"

function log {
  local level="$1"
  local message="$2"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local log_entry="$timestamp [$level] - $message"

  echo "$log_entry" | tee -a "$LOGFILE"
}

log "INFO" "Beginning custom_data script. This is the project ID: ${project_id}"

log "INFO" "Installing required packages"
curl -OL https://go.dev/dl/go1.23.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.23.1.linux-amd64.tar.gz

log "INFO" "Setting up environment variables for go application"
export PATH=$PATH:/usr/local/go/bin
export HOME="/tmp/home"
export GOPATH="/tmp/go"
export GOMODPATH="/tmp/go/pkg/mod"
export GOCACHE="/tmp/go/cache"
export HCP_CLIENT_ID=${client_id}
export HCP_CLIENT_SECRET=${client_secret}
export HCP_ORGANIZATION_ID=${org_id}
export HCP_PROJECT_ID=${project_id}

log "INFO" "Cloning the terramino-go repository"
cd /tmp
git clone https://github.com/hashicorp-education/terramino-go.git
cd terramino-go

# Temporarily checkout a previous version of terramino-go
git checkout 58d39908e07424cba3b0c2f2d9588d9cebfa476b

log "INFO" "Building the terramino-go application"
APP_NAME=${app_name} TERRAMINO_PORT=${port} nohup go run main.go &
