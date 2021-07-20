FROM nestybox/ubuntu-focal-systemd-docker:latest

# Docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Code Server
# # https://github.com/cdr/code-server/blob/main/ci/release-image/Dockerfile
RUN apt-get update \
    && apt-get install -y \
    curl \
    openssh-client \
    dumb-init \
    zsh \
    htop \
    locales \
    man \
    nano \
    git \
    procps \
    sudo \
    vim.tiny \
    lsb-release \
    iputils-ping \
    dnsutils \
    wget \
    build-essential \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --gecos '' --disabled-password brev && \
    echo "brev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN usermod -a -G docker brev

RUN curl -fsSL https://raw.githubusercontent.com/brevdev/code-server/main/install.sh | sh

COPY code-server.service /lib/systemd/system/

RUN ln -sf /lib/systemd/system/code-server.service /etc/systemd/system/multi-user.target.wants/code-server.service

WORKDIR /home/brev/workspace

USER brev

RUN mkdir /home/brev/tmp \
    && echo "export TMPDIR=$HOME/tmp" >> /home/brev/.bashrc

USER root

EXPOSE 22778
