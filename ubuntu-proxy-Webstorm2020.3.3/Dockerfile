FROM brevdev/workspace-ubuntu-20:latest

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

# Projector
RUN pip3 install projector-installer
RUN projector --accept-license autoinstall --config-name Webstorm2020.3.3 --ide-name Webstorm\ 2020.3.3 --port 49152
