#!/bin/bash
#
# Creates a standard tmux session based on a predefined layout.
#
# The tmux flags being used.
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

init $@
