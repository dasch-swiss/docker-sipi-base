# Pull base image.
FROM ubuntu:14.04

MAINTAINER Ivan Subotic <ivan.subotic@unibas.ch>

# Silence debconf messages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install software-properties-common && \
  add-apt-repository ppa:ubuntu-toolchain-r/test && \
  apt-get update && \
  apt-get -y install g++-5 && \
  apt-get -y install cmake && \
  apt-get -y install openjdk-7-jdk && \
  apt-get -y install build-essential && \
  apt-get -y install byobu curl git htop man vim wget && \
  apt-get -y install unzip && \
  apt-get -y install zlib1g-dev && \
  apt-get -y install gettext && \
  apt-get -y install doxygen && \
  apt-get -y install libreadline-dev && \
  apt-get -y install liblog4cpp5-dev && \
  apt-get -y install libssl-dev && \
  ln -sf /usr/bin/g++-5 /usr/bin/g++ && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64" CXX="g++-5" CC="gcc-5"

