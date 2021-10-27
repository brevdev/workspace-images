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
RUN projector --accept-license autoinstall --config-name IDEACommunity2020.3.4 --ide-name IntelliJ\ IDEA\ Community\ Edition\ 2020.3.4 --port 49154

COPY projector-ideacommunity.service /lib/systemd/system/
RUN ln -sf /lib/systemd/system/projector-ideacommunity.service /etc/systemd/system/multi-user.target.wants/projector-ideacommunity.service
