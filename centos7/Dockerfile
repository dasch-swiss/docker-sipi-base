# Pull base image.
FROM centos:7

MAINTAINER Ivan Subotic <ivan.subotic@unibas.ch>

# Install.
RUN \
  yum update -y && \
  yum install -y gcc-c++ && \
  yum install -y git && \
  yum install -y make && \
  yum install -y cmake && \
  yum install -y readline-devel && \
  yum install -y gettext && \
  yum install -y vim-common && \
  yum install -y zlib-devel && \
  yum install -y unzip && \
  yum install -y patch && \
  yum install -y openssl-devel && \
  yum install -y file-devel
  

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64" CXX="g++-5" CC="gcc-5"

