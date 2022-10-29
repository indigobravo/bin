#!/usr/bin/env bash
#
# https://github.com/indigobravo/bin/blob/main/tmux_wrapper.sh

set -o errexit
set -o nounset
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

function usage() {
  echo "TMUX Session Manager"
  echo
  echo "Creates a tmux session based on a predefined layout."
  echo
  echo "3 windows are created.."
  echo "- dev"
  echo "- cmd"
  echo "- ssh"
  echo 
  echo "Usage: $(basename "$0") <session_name>"
  echo
  echo "<session_name> defaults to 'develop'"
}

if [[ "$#" -gt 1 ]]; then
  usage >&2
  exit 1
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
  usage
  exit
fi

# The tmux flags being used.
#
# http://man.openbsd.org/OpenBSD-current/man1/tmux.1
# https://github.com/tmux/tmux/wiki
#
# -d enables commands to complete in a detached mode
# -s the name for a new session
# -n the name for a new window
# -t the name of a session to attach

function attach() {
  local session="$1"

  tmux attach-session -t "$session"
}

function create() {
  local session="$1"

  tmux new-session -d -s "$session"

  tmux rename-window dev
  tmux new-window -d -n cmd
  tmux new-window -d -n ssh

  tmux attach-session -d -t "$session"
}

function init() {
  local session="${1:-develop}"

  if tmux has-session -t "$session" 2> /dev/null ; then
    attach "$session"
  else
    create "$session"
  fi
}

init "$@"
