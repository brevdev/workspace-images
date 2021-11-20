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
  docker-ce docker-ce-cli containerd.io &&                       \
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
  openssh-server &&                                         \
  mkdir /home/brev/.ssh &&                                         \
  chown brev:brev /home/brev/.ssh

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
  lsof

RUN yes | unminimize
# Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

######################
###### SOFTWARE ######
######################

# Code Server + VSCode
RUN curl -fsSL https://raw.githubusercontent.com/brevdev/code-server/main/install.sh | sh
COPY code-server.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/code-server.service /etc/systemd/system/multi-user.target.wants/code-server.service
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

# brev cli
RUN sh -c "`curl -sf -L https://raw.githubusercontent.com/brevdev/brev-cli/main/bin/install-latest.sh`"


############################
###### MACHINE CONFIG ######
############################

RUN chown brev /home/brev/.config
WORKDIR /home/brev/workspace
EXPOSE 22778

###################################
#### UX & QUALITY IMPROVEMENTS ####
###################################
ENV GIT_PAGER=cat

# The following didn't work for some reason. Couldn't find the file speedtest.py
COPY speedtest.py ./speedtest.py
RUN python speedtest.py && cat 01-BREV.sh | sudo tee /etc/update-motd.d/00-header
