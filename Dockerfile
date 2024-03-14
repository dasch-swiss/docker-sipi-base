#
# The base image layer. Per default, FROM uses the $TARGETPLATFORM.
#
FROM ubuntu:22.04 as base

LABEL maintainer="400790+subotic@users.noreply.github.com"

# Silence debconf messages
ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list  \
  && apt-get clean \
  && apt-get -qq update  \
  && apt-get -y install \
    ca-certificates \
    gnupg2 \
    gpg \
    curl git vim unzip wget \
    software-properties-common \
  && apt-get clean

# Install Kitware repository \
RUN bash -c "sh <(curl -sL https://apt.kitware.com/kitware-archive.sh)" \
  && apt-get -qq update

# Install build dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-add-repository "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu jammy main" \
  && apt-get clean \
  && apt-get -qq update \
  && apt-get -y install \
    cmake \
    g++13 \
    valgrind \
    curl \
    libcurl4-openssl-dev \
    openssl \
    libssl-dev \
    doxygen \
    libreadline-dev  \
    libacl1-dev \
    gettext \
    libmagic-dev \
    pkg-config \
    gperf \
    libidn11-dev \
    locales \
    uuid \
    uuid-dev \
    ffmpeg \
    at \
    libmagic-dev \
    file \
    libnuma-dev \
  && apt-get clean
    

# add locales
RUN locale-gen en_US.UTF-8 \
    && locale-gen sr_RS.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN printenv

# Set compiler environment variables
ENV CC=gcc
ENV CXX=g++

RUN printenv

# Install additional test dependencies.
RUN apt-get -y install  \
    nginx \
    libtiff5-dev \
    libopenjp2-7-dev \
    graphicsmagick \
    apache2-utils \
    imagemagick \
    libxml2 \
    libxml2-dev \
    libxslt1.1 \
    libxslt1-dev \
  && apt-get clean

# Install python and python packages
RUN apt-get -y install \
    python3.11 \
    python3-pip && \
    pip3 install \
    Sphinx \
    pytest \
    requests \
    psutil \
    iiif_validator && \
    rm -rf /var/lib/apt/lists/* \
  && apt-get clean


#
# The linux/amd64 variant (e.g., Intel CPUs, etc.)
#
FROM base as platform-linux-amd64

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64


#
# The linux/arm64 variant (e.g., Apple Silicon CPUs, Amazon ARM instances, etc.)
#
FROM base as platform-linux-arm64

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/temurin-17-jdk-arm64


# -----------------------------------------------------
# This needs to be at the end before the final FROM
# Expose global variables
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

#
# The final platform specific image
#
FROM platform-${TARGETOS}-${TARGETARCH}
