##
# Build code-server
##
ARG VERSION_CODE_SERVER="3.9.1"

FROM codercom/code-server:${VERSION_CODE_SERVER}

##
# Install developer utilities
##
USER root

RUN apt-get update && apt-get install -y \
      python3-pip

RUN pip3 install Flask

##
# Install code-server extensions
##
USER coder

ARG VERSION_EXTENSION_PYTHON="2021.2.633441544"

RUN code-server --install-extension ms-python.python@${VERSION_EXTENSION_PYTHON}
RUN /usr/bin/python3 /home/coder/.local/share/code-server/extensions/ms-python.python-${VERSION_EXTENSION_PYTHON}/pythonFiles/pyvsc-run-isolated.py pip install -U flake8 --user

##
# Prepare workspace
##
ENV PATH="/home/coder/.local/bin:${PATH}"

WORKDIR /home/coder/workspace
ADD ../.vscode ./.vscode
ADD ../app.py ./
