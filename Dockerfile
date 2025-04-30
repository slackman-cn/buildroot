FROM ubuntu:22.04
LABEL \
    org.opencontainers.image.title="Buildroot 2025.02 SDK" \
    org.opencontainers.image.vendor="Ubuntu22 build system" \
    org.opencontainers.image.licenses="Apache" \
    org.opencontainers.image.created="2025-04-09" \
    maintainer="slackman.cn"

ENV DEBIAN_FRONTEND=noninteractive \
    FORCE_UNSAFE_CONFIGURE=1 \
    TZ=Asia/Shanghai \
    SDK=buildroot-2025.02
    
RUN apt-get update && apt-get install -y --no-install-recommends tzdata language-pack-en \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# Install base-devel
RUN apt-get install -y \
    build-essential less wget curl file \
    vim git zip unzip rsync cpio bc \
    dialog ncurses-base ncurses-bin libncurses5-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG CHECKSUM=f9444c2e3054e0b3d0f555ab8130520bd08cdb95196233672b52b9569d14c97f 

WORKDIR /build
ADD --checksum=sha256:${CHECKSUM} https://buildroot.org/downloads/${SDK}.tar.gz .

RUN tar -xf ${SDK}.tar.gz && cd ${SDK} \
    && make defconfig \
    && make source


CMD ["/bin/bash"]
