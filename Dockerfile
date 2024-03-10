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
    byobu curl git htop man vim unzip wget \
  && apt-get clean

# Install build dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
  && wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/trusted.gpg.d/adoptium.asc \
  && apt-get clean \
  && apt-get -qq update \
  && apt-get -y install \
    make \
    # LLVM
    libllvm-18-ocaml-dev libllvm18 llvm-18 llvm-18-dev llvm-18-doc llvm-18-examples llvm-18-runtime \
    # Clang and co
    clang-18 clang-tools-18 clang-18-doc libclang-common-18-dev libclang-18-dev libclang1-18 clang-format-18 python3-clang-18 clangd-18 clang-tidy-18 \
    # compiler-rt
    libclang-rt-18-dev \
    # polly
    libpolly-18-dev \
    # libfuzzer
    libfuzzer-18-dev \
    # lldb
    lldb-18 \
    # lld (linker)
    lld-18 \
    # libc++
    libc++-18-dev libc++abi-18-dev \
    # OpenMP
    libomp-18-dev \
    # libclc
    libclc-18-dev \
    # libunwind
    libunwind-18-dev \
    # mlir
    libmlir-18-dev mlir-18-tools \
    # bolt
    libbolt-18-dev bolt-18 \
    # flang
    install flang-18 \
    # wasm support
    libclang-rt-18-dev-wasm32 libclang-rt-18-dev-wasm64 libc++-18-dev-wasm32 libc++abi-18-dev-wasm32 libclang-rt-18-dev-wasm32 libclang-rt-18-dev-wasm64 \
    valgrind \
    temurin-17-jdk \
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

# Set compiler environment variables
ENV CC=clang-14
ENV CXX=clang++-14

# Install newer CMake version
ENV CMAKE_VERSION 3.27.8
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
  && tar -zxvf cmake-${CMAKE_VERSION}.tar.gz \
  && cd cmake-${CMAKE_VERSION} \
  && ./bootstrap \
  && make \
  && make install \
  && cmake --version

# Install sentry-cli
ENV SENTRY_CLI_VERSION 2.21.5
RUN curl -sL https://sentry.io/get-cli/ | SENTRY_CLI_VERSION=${SENTRY_CLI_VERSION} bash

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
