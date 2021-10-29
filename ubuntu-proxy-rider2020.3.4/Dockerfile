FROM brevdev/ubuntu-proxy:0.1.14

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
USER brev
RUN projector --accept-license autoinstall --config-name Rider2020.3.4 --ide-name Rider\ 2020.3.4 --port 49162
USER root

COPY projector-rider.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/projector-rider.service /etc/systemd/system/multi-user.target.wants/projector-rider.service
