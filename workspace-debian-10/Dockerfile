##
# Build code-server
##
ARG VERSION_CODE_SERVER="3.9.1"

FROM codercom/code-server:${VERSION_CODE_SERVER}

##
# Install developer utilities
##
USER root

RUN apt-get update

##
# Prepare workspace
##
ENV PATH="/home/coder/.local/bin:${PATH}"
ADD ../.vscode /home/coder/workspace/.vscode

RUN chown -R coder:coder /home/coder/workspace

##
# Prepare workspace
##
USER coder

ENV PATH="/home/coder/.local/bin:${PATH}"

WORKDIR /home/coder/workspace
