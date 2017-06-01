## Pull base image.
FROM ubuntu:16.04

MAINTAINER Ivan Subotic <ivan.subotic@unibas.ch>

# Silence debconf messages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get -qq update && apt-get -y install \
  openjdk-8-jdk \
  build-essential \
  byobu curl git htop man vim wget unzip \
  g++-5 \
  cmake \
  libssl-dev \
  doxygen \
  libreadline-dev \
  gettext \
  nginx \
  python3 \
  python3-pip \
  libmagic-dev \
  graphicsmagick && \
  chown -R $USER /var/log/nginx && \
  pip3 install --upgrade pip && pip3 install \
  Sphinx \
  pytest \
  requests \
  psutil \
  iiif_validator && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" CXX="g++-5" CC="gcc-5"