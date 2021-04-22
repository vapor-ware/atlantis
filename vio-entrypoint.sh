#!/bin/sh

# If we have a GITHUB_SSH_KEY location, clone into the atlantis $HOME/.ssh and
# assume ownership.

if [ ! -z "${ATLANTIS_GITHUB_SSH_KEY}" ]; then
    mkdir -p $HOME/.ssh
    cat ${ATLANTIS_GITHUB_SSH_KEY} > $HOME/.ssh/id_rsa
    chmod 0700 $HOME/.ssh
    chmod -R 0600 $HOME/.ssh/*
    ssh-keyscan github.com > $HOME/.ssh/known_hosts
fi

# We've done our custom overrides to the init process, go ahead
# and initiate the original entrypoint provided by the runatlantis/atlantis container image

# IDK why, but this exists in path. so go atlantis team. yay
docker-entrypoint.sh