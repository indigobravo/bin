#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

: "${KEY_FILE:="indigobravo"}"
: "${REMOTE:="git@github.com:indigobravo/bin.git"}"
: "${BRANCH:="main"}"

function usage() {
  echo "Usage: $(basename "$0")"
  echo 
  echo "Clone a private GitHub repository using SSH. Defaults to:"
  echo "  - indigobravo/bin"
  echo
  echo "Override environment variables as required..."
  echo
  echo "KEY_FILE"
  echo "A private SSH key. The public part will have been added to"
  echo "GitHub as a deploy key"
  echo
  echo "REMOTE"
  echo "The full URL of the remote repository including the user"
  echo
  echo "BRANCH"
  echo "The branch of the GitHub repository to be cloned."
}

if [[ "$#" -ge 1 ]]; then
  usage >&2
  exit 1
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
  usage
  exit
fi

if [ -f $KEY_FILE ] ; then
  eval "$(ssh-agent -s)"
  ssh-add "$KEY_FILE"
else
  echo "failed to locate: $KEY_FILE" >&2
  exit 2
fi

export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

git clone --branch $BRANCH $REMOTE
