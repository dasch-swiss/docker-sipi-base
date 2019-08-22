## Pull base image.
FROM ubuntu:18.04

LABEL maintainer="Ivan.Subotic@unibas.ch"

# Silence debconf messages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# The CMake version which should be downloaded and installed
ENV CMAKE_VERSION 3.14.5

# Install base tools.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get clean && apt-get -qq update && apt-get -y install \
    openssl \
    byobu curl git htop man vim wget unzip

# Install build tools.
RUN apt-get clean && apt-get -y install \
    build-essential \
    ninja-build \
    libllvm-7-ocaml-dev libllvm7 llvm-7 llvm-7-dev llvm-7-doc llvm-7-examples llvm-7-runtime \
    clang-7 clang-tools-7 clang-7-doc libclang-common-7-dev libclang-7-dev libclang1-7 clang-format-7 python-clang-7 \
    libfuzzer-7-dev \
    lldb-7 \
    lld-7 \
    libc++-7-dev libc++abi-7-dev \
    libomp-7-dev \
    g++

# Install newer CMake version (Ubuntu 18.04 default is CMake 3.10.2)
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
    tar -zxvf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && \
    make && \
    make install

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
# ENV CXX="g++-5"
# ENV CC="gcc-5"
ENV CC clang-7
ENV CFLAGS "-march=native -Ofast"
ENV CXX clang++-7
ENV CXXFLAGS "-march=native -Ofast"

# Install build dependencies.
RUN apt-get clean && apt-get -y install \
    openjdk-8-jdk \
    libssl-dev \
    doxygen \
    libreadline-dev \
    gettext \
    libmagic-dev \
    pkg-config \
    util-linux \
    gperf

# Install additional test dependencies.
RUN apt-get clean && apt-get -y install \
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
RUN apt-get clean && apt-get -y install \
    python3 \
    python3-pip && \
    pip3 install \
    Sphinx \
    pytest \
    requests \
    psutil \
    iiif_validator && \
    rm -rf /var/lib/apt/lists/*
