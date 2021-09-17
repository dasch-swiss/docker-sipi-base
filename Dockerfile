#
# The base image layer. Per default, FROM uses the $TARGETPLATFORM.
#
FROM ubuntu:20.04 as base

LABEL maintainer="400790+subotic@users.noreply.github.com"

# Silence debconf messages
ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get clean && apt-get -qq update && apt-get -y install \
    ca-certificates \
    gnupg2

# Install build dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main' | tee -a /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main' | tee -a /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 15CF4D18AF4F7421 && \
    apt-get clean && apt-get -qq update && apt-get -y install \
    ca-certificates \
    byobu curl git htop man vim wget unzip \
    build-essential \
    ninja-build \
    cmake \
    libllvm-11-ocaml-dev libllvm11 llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime \
    clang-11 clang-tools-11 clang-11-doc libclang-common-11-dev libclang-11-dev libclang1-11 clang-format-11 \
    libfuzzer-11-dev \
    lldb-11 \
    lld-11 \
    libc++-11-dev libc++abi-11-dev \
    libomp-11-dev \
    g++-10 \
    openjdk-11-jdk \
    openssl \
    libssl-dev \
    doxygen \
    libreadline-dev \
    gettext \
    libmagic-dev \
    pkg-config \
    util-linux \
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
ENV CC clang-11
ENV CXX clang++-11

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
    python3.9 \
    python3-pip && \
    pip3 install \
    Sphinx \
    pytest \
    requests \
    psutil \
    iiif_validator && \
    rm -rf /var/lib/apt/lists/*


#
# The linux/amd64 variant (e.g., Intel CPUs, etc.)
#
FROM base as platform-linux-amd64-

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Install Bazelisk
RUN curl -Lo /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-amd64 && \
    chmod +x /usr/local/bin/bazel


#
# The linux/arm64 variant (e.g., Apple Silicon CPUs, Amazon ARM instances, etc.)
#
FROM base as platform-linux-arm64-

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64

# Install Bazelisk
RUN curl -Lo /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-arm64 && \
    chmod +x /usr/local/bin/bazel


#
# The linux/arm/v7 variant (e.g., Raspberry Pi, etc.)
#
FROM base as platform-linux-arm-v7

# TODO: need to find which java and how to compile bazelisk for Pi.
# ARG TARGETOS
# ARG TARGETARCH
# ENV GOOS=$TARGETOS GOARCH=$TARGETARCH
# RUN go build ...



# Expose global variables
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

#
# The final platform specific image
#
FROM platform-${TARGETOS}-${TARGETARCH}-${TARGETVARIANT}
