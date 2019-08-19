## Pull base image.
FROM ubuntu:18.04

LABEL maintainer="Ivan.Subotic@unibas.ch"

# Silence debconf messages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# The CMake version which should be downloaded and installed
ENV CMAKE_VERSION 3.14.5

# Install build dependencies.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get -qq update && apt-get -y install \
  openjdk-8-jdk \
  build-essential \
  byobu curl git htop man vim wget unzip \
  g++-5 \
  libssl-dev \
  doxygen \
  libreadline-dev \
  gettext \
  libmagic-dev \
  pkg-config \
  util-linux \
  gperf

# Install newer CMake version (Ubuntu 18.04 default is CMake 3.10.2)
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
  tar -zxvf cmake-${CMAKE_VERSION}.tar.gz && \
  cd cmake-${CMAKE_VERSION} && \
  ./bootstrap && \
  make && \
  make install

# Install additional test dependencies.
RUN apt-get -y install \
  nginx \
  libtiff5-dev \
  libopenjp2-7-dev \
  graphicsmagick \
  apache2-utils && \
  wget https://www.imagemagick.org/download/ImageMagick.tar.gz && \
  tar xf ImageMagick.tar.gz && \
  cd ImageMagick-7* && \
  ./configure && \
  make && \
  make install && \
  ldconfig /usr/local/lib

# Install python and python packages
RUN apt-get -y install \
  python3 \
  python3-pip && \
  pip3 install \
  Sphinx \
  pytest \
  requests \
  psutil \
  iiif_validator && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" CXX="g++-5" CC="gcc-5"
