#
# The base image layer. Per default, FROM uses the $TARGETPLATFORM.
#
FROM ubuntu:22.04

LABEL maintainer="400790+subotic@users.noreply.github.com"

# Silence debconf messages
ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get clean && apt-get -qq update && apt-get -y install \
    ca-certificates \
    gnupg2 \
    wget

# Install build dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    echo 'deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-14 main' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-14 main' | tee -a /etc/apt/sources.list && \
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/myrepo.asc && \
    apt-get clean && apt-get -qq update && apt-get -y install \
    byobu curl git htop man vim wget unzip \
    build-essential \
    cmake \
    libllvm-14-ocaml-dev libllvm14 llvm-14 llvm-14-dev llvm-14-doc llvm-14-examples llvm-14-runtime \
    clang-14 clang-tools-14 clang-14-doc libclang-common-14-dev libclang-14-dev libclang1-14 clang-format-14 python3-clang-14 clangd-14 clang-tidy-14 \
    libfuzzer-14-dev lldb-14 lld-14 libc++-14-dev libc++abi-14-dev libomp-14-dev \
    g++-12 \
    valgrind \
    openjdk-17-jdk \
    openssl \
    libssl-dev \
    doxygen \
    libreadline-dev \
    gettext \
    libmagic-dev \
    pkg-config \
    gperf \
    libidn11-dev \
    locales \
    uuid \
    uuid-dev \
    ffmpeg \
    at
    

# add locales
RUN locale-gen en_US.UTF-8 && \
    locale-gen sr_RS.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Set environment variables
ENV CC clang-14
ENV CXX clang++-14

# Install additional test dependencies.
RUN apt-get clean && apt-get -y install \
    nginx \
    libtiff5-dev \
    libopenjp2-7-dev \
    graphicsmagick \
    apache2-utils \
    imagemagick \
    libxml2 \
    libxml2-dev \
    libxslt1.1 \
    libxslt1-dev

# Install python and python packages
RUN apt-get clean && apt-get -y install \
    python3.10 \
    python3-pip && \
    pip3 install \
    Sphinx \
    pytest \
    requests \
    psutil \
    iiif_validator && \
    rm -rf /var/lib/apt/lists/*
