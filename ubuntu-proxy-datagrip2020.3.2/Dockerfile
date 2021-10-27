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
RUN projector --accept-license autoinstall --config-name DataGrip2020.3.2 --ide-name DataGrip\ 2020.3.2 --port 49159

COPY projector-datagrip.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/projector-datagrip.service /etc/systemd/system/multi-user.target.wants/projector-datagrip.service
