FROM phusion/baseimage:latest-amd64

## Phusion base Image
# https://hub.docker.com/r/phusion/baseimage/tags

## OpenCV Installing example using Alpine
# https://qiita.com/teratsyk/items/7d7b401001c09e3694ab

## OpenCV Releases
# https://github.com/opencv/opencv/releases

## Configuring the locales and language settings to UTF-8.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## OpenCV Release version
ENV OPENCV_VERSION=4.1.1

## Install required packages
WORKDIR /root
ADD ./packages-base.txt /root
RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y $(cat packages-base.txt) && \
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

## Install OpenCV
RUN mkdir -p /opt && cd /opt && \
  wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
  unzip ${OPENCV_VERSION}.zip && \
  rm -rf ${OPENCV_VERSION}.zip

RUN mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
	cd /opt/opencv-${OPENCV_VERSION}/build && \
	cmake \
	-D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D WITH_FFMPEG=NO \
	-D WITH_IPP=NO \
	-D WITH_OPENEXR=NO \
	-D WITH_TBB=YES \
	-D BUILD_EXAMPLES=NO \
	-D BUILD_ANDROID_EXAMPLES=NO \
	-D INSTALL_PYTHON_EXAMPLES=NO \
	-D BUILD_DOCS=NO \
	-D BUILD_opencv_python2=NO \
	-D BUILD_opencv_python3=ON \
	-D PYTHON3_EXECUTABLE=/usr/bin/python .. && \
	make VERBOSE=1 && \
	make -j $(nproc) && \
	make install && \
	rm -rf /opt/opencv-${OPENCV_VERSION}

## Clear
RUN apt-get clean

## Setting Workdir
WORKDIR /home/jupyter/notebooks

## Adding a script to enable extensions and start jupyter.
ADD start_jupyter.sh /usr/local/bin/start_jupyter.sh

## Exponsing port 8888
EXPOSE 8888

## Starting jupyter notebook using the script and the created user.
CMD ["bash", "/usr/local/bin/start_jupyter.sh"]