FROM alpine:latest

## Configuring the locales and language settings to UTF-8.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Add Edge repos
RUN echo -e "\n\
@edgemain http://nl.alpinelinux.org/alpine/edge/main\n\
@edgecomm http://nl.alpinelinux.org/alpine/edge/community\n\
@edgetest http://nl.alpinelinux.org/alpine/edge/testing"\
  >> /etc/apk/repositories

## Install required packages
WORKDIR /root
ADD ./packages-base.txt /root
RUN apk update && apk upgrade && \
	apk --no-cache add $(cat packages-base.txt) && \
	rm -rf /root/packages-base.txt

## Python 3 as default
RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
	ln -s /usr/bin/pip3 /usr/local/bin/pip && \
	pip install --upgrade pip setuptools

## Install all requirements
WORKDIR /root
ADD ./requirements.txt /root
RUN pip3 install --upgrade $(cat requirements.txt) && \
	rm -rf /root/requirements.txt

## Clean Up
RUN rm -rf /var/cache/apk/* && rm -rf /root/.cache

## Setting Workdir
WORKDIR /home/jupyter/notebooks

## Adding a script to enable extensions and start jupyter.
ADD start_jupyter.sh /usr/local/bin/start_jupyter.sh

## Exponsing port 8888
EXPOSE 8888

## Starting jupyter notebook using the script and the created user.
CMD ["bash", "/usr/local/bin/start_jupyter.sh"]