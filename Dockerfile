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
  && apt-get -y install curl git vim unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install required packages, add the PPA for GCC 13, and install GCC 13
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list  \
  && apt-get update \
  && apt-get install -y software-properties-common build-essential \
  && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
  && apt-get update \
  && apt-get install -y gcc-13 g++-13 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set GCC 13 as the default gcc and g++
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 60 --slave /usr/bin/g++ g++ /usr/bin/g++-13

# Verify the installation
RUN gcc --version && g++ --version

# Install Kitware repository \
RUN bash -c "sh <(curl -sL https://apt.kitware.com/kitware-archive.sh)" \
  && apt-get -qq update \
  && apt-get -y install cmake \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install build dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-get clean \
  && apt-get -qq update \
  && apt-get -y install \
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
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN which cmake
RUN cmake --version

# add locales
RUN locale-gen en_US.UTF-8 \
    && locale-gen sr_RS.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Set compiler environment variables
ENV CC=gcc
ENV CXX=g++

# Install additional test dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-get -qq update \
  && apt-get -y install \
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
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install python and python packages
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-get -qq update \
  && apt-get -y install \
    python3.11 \
    python3-pip && \
    pip3 install \
    Sphinx \
    pytest \
    requests \
    psutil \
    iiif_validator && \
    rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


#
# The linux/amd64 variant (e.g., Intel CPUs, etc.)
#
FROM base as platform-linux-amd64


#
# The linux/arm64 variant (e.g., Apple Silicon CPUs, Amazon ARM instances, etc.)
#
FROM base as platform-linux-arm64


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
