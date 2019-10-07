#!/bin/bash

# Exit if any command fails
set -e

# Trying to get the Docker System Version
DOCKER_VERSION=`docker --version`

# Exit if Docker is not installed or running
if [[ -z $DOCKER_VERSION ]]; then
    echo -e "\nError: Did you install Docker? Please, verify the installation or if it is really running...\n"
    exit 1
else
    echo -e "\n$DOCKER_VERSION is running!!"
fi

# Logging into DockerHub
echo -e "\nLoggin to DockerHub with an existing account"
docker login

# Building the new image
echo -e "\nBuilding new Jupyter Image.."
docker build -t csbrunonovo/jupyter_notebook_docker .

# Pushing the new image to DockerHub
echo -e "\nPushing the new Jupyter Image to DockerHub.."
docker push csbrunonovo/jupyter_notebook_docker:latest