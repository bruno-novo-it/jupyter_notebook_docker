#!/bin/bash

DOCKER_VERSION=`docker --version`

if [[ -z $DOCKER_VERSION ]]; then
    echo -e "\nError: Did you install Docker? Please, verify the installation or if it is really running...\n"
    exit 1
else
    echo -e "\n$DOCKER_VERSION is running!!"
fi

echo -e "\nLoggin to DockerHub with an existing account"
docker login

echo -e "\nBuilding new Jupyter Image.."
docker build -t csbrunonovo/jupyter_notebook_docker .

echo -e "\nPushing the new Jupyter Image to DockerHub.."
docker push csbrunonovo/jupyter_notebook_docker:latest