FROM ubuntu:focal

RUN apt-get update \
    && apt-get install -y \
    curl 

RUN curl -fsSL https://raw.githubusercontent.com/brevdev/code-server/main/install.sh | sh

COPY ./config.yaml /root/.config/code-server/config.yaml

EXPOSE 8080
CMD [ "/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080" ]