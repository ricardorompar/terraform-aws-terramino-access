#!/bin/bash

curl -OL https://go.dev/dl/go1.23.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.23.1.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin
export HOME="/tmp/home"
export GOPATH="/tmp/go"
export GOMODPATH="/tmp/go/pkg/mod"
export GOCACHE="/tmp/go/cache"
export HCP_CLIENT_ID=${client_id}
export HCP_CLIENT_SECRET=${client_secret}
export HCP_ORGANIZATION_ID=${org_id}
export HCP_PROJECT_ID=${project_id}

cd /tmp
git clone https://github.com/hashicorp-education/terramino-go.git
cd terramino-go

# Temporarily checkout a previous version of terramino-go
git checkout 58d39908e07424cba3b0c2f2d9588d9cebfa476b

APP_NAME=${app_name} TERRAMINO_PORT=${port} go run main.go
