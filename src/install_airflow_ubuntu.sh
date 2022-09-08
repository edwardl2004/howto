#!/bin/bash

# Uninstall old version of dockers
sudo apt-get remove docker docker-engine docker.io containerd runc

# Update apt package
sudo apt-get update
sudo apt-get upgrade

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Setup apt repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker engine
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install docker-compose
sudo apt-get install docker-compose

# Upgrade docker-compose to v1.29.2
sudo cp /usr/bin/docker-compose /usr/bin/docker-compose_old
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

# Check memory for docker engine. 4GB is required.
docker run --rm "debian:bullseye-slim" bash -c 'numfmt --to iec $(echo $(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE))))'

# Get docker compose file for Airflow 2.3.3
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.3.3/docker-compose.yaml'

# Configure folder and env file for Airflow
mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

# Initialise database
sudo docker-compose up airflow-init
