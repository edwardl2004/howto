# Summary

This page describes the steps to install Airflow in ubuntu instance throught docker.
The steps were tested on Ububtu 18.04. The minimum memory size of the instance is 4GB.
The steps were composed based on the contents of the following links:
https://docs.docker.com/engine/install/ubuntu/
https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html
https://www.youtube.com/watch?v=K9AnJ9_ZAXE&t=1225s 

# Install docker engine
## Uninstall old version of docker
Run the command to uninstall older version of dockers:
`sudo apt-get remove docker docker-engine docker.io containerd runc`

## Update apt packages
Run the command:
`sudo apt-get update`
`sudo apt-get upgrade`

## Install supporting packages
Run the commands:
`sudo apt-get install ca-certificates curl gnupg lsb-release`

## Add docker's official GPG key
`sudo mkdir -p /etc/apt/keyrings`
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`

## Setup apt repository
`echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

## Install docker engine
`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin`

## Check memory for docker engine
Run the following command to check the memory for docker engine:
`docker run --rm "debian:bullseye-slim" bash -c 'numfmt --to iec $(echo $(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE))))'`

For running airflow, minimum 4GB is required. The RAM size of Ubuntu instance must be larger than 4GB.

# Install docker-compose
`sudo apt-get install docker-compose`

## Upgrade docker-compose
Airflow docker compose file requires docker-compose version 1.29.1 and newer. Run the command to check the installed docker-compose version:
`docker-compose --version`

If the installed version is lower than 1.29.1, run the following command to upgrade:
`sudo cp /usr/bin/docker-compose /usr/bin/docker-compose_old`
`sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose`

docker-compose version 1.29.2 was proven to work.

# Install Airflow
## Download Airflow docker compose file
`curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.3.3/docker-compose.yaml'`

## Configure folder and env file for Airflow
`mkdir -p ./dags ./logs ./plugins`
`echo -e "AIRFLOW_UID=$(id -u)" > .env`

## Initialise database
`sudo docker-compose up airflow-init`
