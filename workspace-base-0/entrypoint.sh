#!/bin/sh
set -eu

# We do this first to ensure sudo works below when renaming the user.
# Otherwise the current container UID may not exist in the passwd database.
eval "$(fixuid -q)"


sudo dockerd > /home/coder/dockerd.log 2>&1 &
# sudo /sbin/init --log-level=err
dumb-init /usr/bin/code-server "$@"
