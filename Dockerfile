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
    software-properties-common \
  && apt-get clean

# Install build dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
  && wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/trusted.gpg.d/adoptium.asc \
  && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor -o /usr/share/keyrings/llvm-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] https://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" | tee /etc/apt/sources.list.d/llvm-17.list \
  && apt-add-repository "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu jammy main" \
  && apt-get clean \
  && apt-get -qq update \
  && apt-get -y install \
    make \
    libllvm-17-ocaml-dev libllvm17 llvm-17 llvm-17-dev llvm-17-doc llvm-17-runtime \
    clang-17 clang-tools-17 clang-17-doc libclang-common-17-dev libclang-17-dev libclang1-17 clang-format-17 python3-clang-17 clangd-17 clang-tidy-17 \
    libclang-rt-17-dev \
    libpolly-17-dev \
    libfuzzer-17-dev \
    lldb-17 \
    lld-17 \
    libc++-17-dev libc++abi-17-dev \
    libomp-17-dev \
    libclc-17-dev \
    libunwind-17-dev \
    libmlir-17-dev mlir-17-tools \
    flang-17 \
    libclang-rt-17-dev-wasm32 libclang-rt-17-dev-wasm64 libc++-17-dev-wasm32 libc++abi-17-dev-wasm32 libclang-rt-17-dev-wasm32 libclang-rt-17-dev-wasm64 \
    g++13 \
    valgrind \
    temurin-17-jdk \
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

# Set compiler environment variables
ENV CC=clang-17
ENV CXX=clang++-17

# Install newer CMake version
ENV CMAKE_VERSION 3.28.3
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
  && tar -zxvf cmake-${CMAKE_VERSION}.tar.gz \
  && cd cmake-${CMAKE_VERSION} \
  && ./bootstrap \
  && make \
  && make install \
  && cmake --version

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
