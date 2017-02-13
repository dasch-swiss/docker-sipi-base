# Pull base image.
FROM ubuntu:16.04

MAINTAINER Ivan Subotic <ivan.subotic@unibas.ch>

# Set timezone
#ENV TZ=ETC/GMT+1
#RUN \
#  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
#  date

# Install dependencies
RUN \
 sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
 && apt-get update && apt-get -y install \
 build-essential \
 cmake \
 doxygen \
 g++-5 \
 gettext \
 git \
 libreadline-dev \
 liblog4cpp5-dev \
 libssl-dev \
 libmagic-dev \
 openjdk-8-jdk \
 unzip \
 vim \
 zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" CXX="g++-5" CC="gcc-5"