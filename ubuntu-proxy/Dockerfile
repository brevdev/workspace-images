###############################################################
###### Instead of pulling from this, vendor it ourselves ######
###### FROM nestybox/ubuntu-focal-systemd:latest         ######
###############################################################

FROM ubuntu:focal

# Systemd installation
RUN apt-get update &&                            \
  apt-get install -y --no-install-recommends   \
  systemd                              \
  systemd-sysv                         \
  libsystemd0                          \
  ca-certificates                      \
  dbus                                 \
  iptables                             \
  iproute2                             \
  kmod                                 \
  locales                              \
  sudo                                 \
  udev &&                              \
  \
  # Prevents journald from reading kernel messages from /dev/kmsg
  echo "ReadKMsg=no" >> /etc/systemd/journald.conf &&               \
  \
  # Housekeeping
  apt-get clean -y &&                                               \
  rm -rf                                                            \
  /var/cache/debconf/*                                           \
  /var/lib/apt/lists/*                                           \
  /var/log/*                                                     \
  /tmp/*                                                         \
  /var/tmp/*                                                     \
  /usr/share/doc/*                                               \
  /usr/share/man/*                                               \
  /usr/share/local/* &&                                          \
  \
  # Create default 'brev/brev' user
  useradd --create-home --shell /bin/bash brev && echo "brev:brev" | chpasswd && adduser brev sudo

# Make use of stopsignal (instead of sigterm) to stop systemd containers.
STOPSIGNAL SIGRTMIN+3

RUN yes | unminimize

# Docker install
RUN apt-get update && apt-get install --no-install-recommends -y      \
  apt-transport-https                                            \
  ca-certificates                                                \
  curl                                                           \
  gnupg-agent                                                    \
  software-properties-common &&                                  \
  \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg           \
  | apt-key add - &&                                           \
  \
  apt-key fingerprint 0EBFCD88 &&                                   \
  \
  add-apt-repository                                                \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu     \
  $(lsb_release -cs)                                             \
  stable" &&                                                     \
  \
  apt-get update && apt-get install --no-install-recommends -y      \
  docker-ce=5:20.10.13~3-0~ubuntu-focal docker-ce-cli=5:20.10.13~3-0~ubuntu-focal containerd.io=1.5.11-1 &&                       \
  \
  # Housekeeping
  apt-get clean -y &&                                               \
  rm -rf                                                            \
  /var/cache/debconf/*                                           \
  /var/lib/apt/lists/*                                           \
  /var/log/*                                                     \
  /tmp/*                                                         \
  /var/tmp/*                                                     \
  /usr/share/doc/*                                               \
  /usr/share/man/*                                               \
  /usr/share/local/* &&                                          \
  \
  # Add user "admin" to the Docker group
  usermod -a -G docker brev

# Sshd install
RUN apt-get update && apt-get install --no-install-recommends -y      \
  openssh-server &&                                                   \
  mkdir /home/brev/.ssh &&                                            \
  chown brev:brev /home/brev/.ssh &&                                  \
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

EXPOSE 22

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]

##################
###### USER ######
##################

# Allow brev to run sudo commands w/o a password
RUN echo "brev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

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
  ca-certificates \
  lsof \
  libpcap-dev

# Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

######################
###### SOFTWARE ######
######################

# Code Server + VSCode
RUN curl -fsSL https://raw.githubusercontent.com/brevdev/code-server/main/install.sh | sh
COPY code-server.service /lib/systemd/system/
RUN mkdir -p /home/brev/.config/code-server
COPY default-code-server.yaml /home/brev/.config/code-server/config.yaml

# Brev vscode Extension
COPY brev-vscode.vsix /home/brev/.config/code-server/brev-vscode.vsix

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

# Emacs & Vim
RUN apt-get install -y emacs vim

############################
###### MACHINE CONFIG ######
############################

RUN chown brev /home/brev/.config
WORKDIR /home/brev/workspace
EXPOSE 22778

###################################
#### UX & QUALITY IMPROVEMENTS ####
###################################
ENV GIT_EDITOR=vim

# The following didn't work for some reason. Couldn't find the file speedtest.py
# COPY speedtest.py ./speedtest.py
COPY speedtest-output.sh ./speedtest-output.sh
# RUN python speedtest.py && cat speedtest-output.sh | sudo tee /etc/update-motd.d/00-header
RUN cat ./speedtest-output.sh > /etc/update-motd.d/00-header
RUN sudo rm /etc/update-motd.d/10-help-text
RUN sudo rm /etc/update-motd.d/50-motd-news

COPY speed_test.py /usr/bin/speedtest

# huproxy
COPY huproxy /usr/bin
RUN huproxy --help
COPY huproxy.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/huproxy.service /etc/systemd/system/default.target.wants/huproxy.service

# brev vpn configure
COPY brev-servicemesh-init.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/brev-servicemesh-init.service /etc/systemd/system/default.target.wants/brev-servicemesh-init.service

# brev setup
COPY brev-setup.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/brev-setup.service /etc/systemd/system/default.target.wants/brev-setup.service

# brevmon
COPY brevmon /usr/bin
COPY brevmon.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/brevmon.service /etc/systemd/system/default.target.wants/brevmon.service

USER brev

# brew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/brev/.bashrc 
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/brev/.zshrc

# vscode-server
COPY download-vscode-server.sh /home/brev
RUN sudo chmod +x /home/brev/download-vscode-server.sh 
RUN /home/brev/download-vscode-server.sh && \
 rm /home/brev/download-vscode-server.sh

RUN echo 'export PATH=`echo ~/.vscode-server/bin/*/bin`:$PATH'; echo 'export VSCODE_IPC_HOOK_CLI=`echo /var/run/user/1000/vscode-ipc-*.sock`' >> /home/brev/.bashrc 
RUN echo 'export PATH=`echo ~/.vscode-server/bin/*/bin`:$PATH'; echo 'export VSCODE_IPC_HOOK_CLI=`echo /var/run/user/1000/vscode-ipc-*.sock`' >> /home/brev/.zshrc 

# brev cli
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install brevdev/homebrew-brev/brev && echo brev --version && echo "67"
# COPY brev /usr/local/bin
# RUN chmod +x  /usr/local/bin/brev

USER root

RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.zshrc

