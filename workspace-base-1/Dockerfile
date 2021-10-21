FROM nestybox/ubuntu-focal-systemd-docker:latest

##################
###### USER ######
##################

# Create Privileged User "Brev"
RUN adduser --gecos '' --disabled-password brev && \
  echo "brev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

###############################
###### BASE DEPENDENCIES ######
###############################

# Code Server Dependencies 
# https://github.com/cdr/code-server/blob/main/ci/release-image/Dockerfile
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
  lsb-release

# Projector Dependencies
RUN apt-get install -y \
  python3 \
  python3-pip \
  python3-cryptography \
  less \
  libxext6 \
  libxrender1 \
  libxtst6 \
  libfreetype6 \
  libxi6

# Other Base Dependencies
RUN apt-get install -y \
  iputils-ping \
  dnsutils \
  wget \
  build-essential \
  zip \
  unzip \
  jq \
  rsync \
  python-is-python3 \
  software-properties-common \
  ca-certificates

# Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN usermod -a -G docker brev
ENV TMPDIR=/home/brev/tmp

USER brev
RUN mkdir /home/brev/tmp
USER root

######################
###### SOFTWARE ######
######################

# Code Server + VSCode
RUN curl -fsSL https://raw.githubusercontent.com/brevdev/code-server/main/install.sh | sh
COPY code-server.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/code-server.service /etc/systemd/system/multi-user.target.wants/code-server.service
RUN mkdir -p /home/brev/.config/code-server
COPY default-code-server.yaml /home/brev/.config/code-server/config.yaml

# VSCode Extension
COPY brev-vscode.vsix /home/brev/.config/code-server/brev-vscode.vsix

# Projector
RUN pip3 install projector-installer
RUN projector --accept-license autoinstall --config-name Webstorm2020.3.3 --ide-name Webstorm\ 2020.3.3 --port 49152
RUN projector --accept-license autoinstall --config-name IDEAUltimate2020.3.4 --ide-name IntelliJ\ IDEA\ Ultimate\ 2020.3.4 --port 49153
RUN projector --accept-license autoinstall --config-name IDEACommunity2020.3.4 --ide-name IntelliJ\ IDEA\ Community\ Edition\ 2020.3.4 --port 49154

# Vault
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install vault
COPY vault-agent.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/vault-agent.service /etc/systemd/system/default.target.wants/vault-agent.service

# Vault-utils
RUN wget https://github.com/brevdev/vault-utils/releases/download/v0.2.0/vault-utils_0.2.0_linux_amd64.tar.gz \
    && tar -xvzf vault-utils_0.2.0_linux_amd64.tar.gz vault-utils \
    && mv vault-utils /usr/local/bin
COPY vault-utils.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/vault-utils.service /etc/systemd/system/default.target.wants/vault-utils.service

############################
###### MACHINE CONFIG ######
############################

WORKDIR /home/brev/workspace
EXPOSE 22778
