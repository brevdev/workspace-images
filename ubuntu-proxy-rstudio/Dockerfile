FROM brevdev/ubuntu-proxy:0.1.14

# RStudio Dependencies
RUN apt-get update &&                            \
    apt-get install -y --no-install-recommends   \
            gdebi-core                           \
            wget                                 \
            software-properties-common           \
            dirmngr                              \
            r-base

ENV R_VERSION=4.0.5

RUN curl -O https://cdn.rstudio.com/r/ubuntu-2004/pkgs/r-4.0.5_1_amd64.deb
RUN gdebi --n r-4.0.5_1_amd64.deb
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
RUN gdebi rstudio-server-1.4.1717-amd64.deb --n
RUN dpkg -i rstudio-server-1.4.1717-amd64.deb

RUN adduser --gecos "" --disabled-password rstudio
RUN chpasswd <<< "rstudio:rstudio"