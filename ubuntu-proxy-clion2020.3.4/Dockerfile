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
RUN projector --accept-license autoinstall --config-name CLion2020.3.4 --ide-name CLion\ 2020.3.4 --port 49157

COPY projector-clion.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/projector-clion.service /etc/systemd/system/multi-user.target.wants/projector-clion.service
