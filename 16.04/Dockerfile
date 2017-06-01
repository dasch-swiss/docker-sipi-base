# Pull base image.
FROM ubuntu:16.04

MAINTAINER Ivan Subotic <ivan.subotic@unibas.ch>

# Silence debconf messages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get -qq update && \
  apt-get -y install openjdk-8-jdk && \
  apt-get -y install build-essential && \
  apt-get -y install byobu curl git htop man vim wget && \
  apt-get -y install unzip && \
  apt-get -y install g++-5 && \
  apt-get -y install cmake && \
  apt-get -y install libssl-dev && \
  apt-get -y install doxygen && \
  apt-get -y install libreadline-dev && \
  apt-get -y install gettext && \
  apt-get -y install nginx && \
  chown -R $USER /var/log/nginx && \
  apt-get -y install python3 && \
  apt-get -y install python3-pip && \
  pip3 install --upgrade pip && \
  apt-get -y install libmagic-dev && \
  apt-get -y install graphicsmagick && \
  pip3 install Sphinx && \
  pip3 install pytest && \
  pip3 install requests && \
  pip3 install psutil && \
  pip3 install iiif_validator && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" CXX="g++-5" CC="gcc-5"
