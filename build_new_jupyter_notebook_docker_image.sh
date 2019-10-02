#!/bin/bash


DOCKER_VERSION=`docker --version`

if [[ -z $DOCKER_VERSION ]]; then
    echo -n "\nError: Did you install Docker? Please, verify the installation or if it is really running...\n"
    exit 1
else
    echo -n "\n$DOCKER_VERSION is running!!\n"
fi

echo -n "\nLoggin to DockerHub with an existing account\n"
docker login

echo -n "\nBuilding new Jupyter Image..\n"
docker build -t csbrunonovo/jupyter_notebook_docker . > /dev/null

echo -n "\nPushing the new Jupyter Image to DockerHub..\n"
docker push csbrunonovo/jupyter_notebook_docker:latest