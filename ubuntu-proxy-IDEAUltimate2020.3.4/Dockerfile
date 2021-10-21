FROM brevdev/workspace-ubuntu-20:latest

# Projector Dependencies
RUN apt-get update &&                            \
    apt-get install -y --no-install-recommends   \
            python3                              \
            python3-pip                          \
            python3-cryptography                 \
            less                                 \
            libxext6                             \
            libxrender1                          \
            libxtst6                             \
            libfreetype6                         \
            libxi6                               

# Projector
RUN pip3 install projector-installer
RUN projector --accept-license autoinstall --config-name IDEAUltimate2020.3.4 --ide-name IntelliJ\ IDEA\ Ultimate\ 2020.3.4 --port 49153

COPY projector-ideaultimate.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/projector-ideaultimate.service /etc/systemd/system/multi-user.target.wants/projector-ideaultimate.service
