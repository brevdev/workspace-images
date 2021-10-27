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
RUN projector --accept-license autoinstall --config-name DataSpell2021.3 --ide-name DataSpell\ EAP\ 2021.3 --port 49163

COPY projector-dataspell.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/projector-dataspell.service /etc/systemd/system/multi-user.target.wants/projector-dataspell.service
