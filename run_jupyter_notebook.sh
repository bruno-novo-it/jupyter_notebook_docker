#!/bin/bash


## Kill the container if it is already running and 
docker rm -f jupyter || true 

## Start up a new instance, using the 8888 port.
docker run -d -it \
    --name jupyter \
    -v "$PWD":/home/jupyter/notebooks \
    -p 8888:8888 \
    csbrunonovo/jupyter_notebook_docker:latest 