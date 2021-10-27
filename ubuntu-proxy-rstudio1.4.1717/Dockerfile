FROM brevdev/ubuntu-proxy:0.1.14

# RStudio Dependencies
RUN apt-get update &&                            \
    apt-get install -y --no-install-recommends   \
            gdebi-core                           \
            wget                                 \
            software-properties-common           \
            dirmngr                              \
            r-base

RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
RUN gdebi rstudio-server-1.4.1717-amd64.deb --n

RUN adduser --gecos "" --disabled-password rstudio
RUN ["/bin/bash", "-c", "chpasswd <<< 'rstudio:rstudio'"]