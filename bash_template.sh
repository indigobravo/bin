#!/usr/bin/env bash
#
# https://github.com/indigobravo/bin/blob/main/bash_template.sh

set -o errexit
set -o nounset
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

function usage() {
  echo "Template BASH Shell Script"
  echo
  echo "Usage: $(basename "$0")"
}

if [[ "$#" -gt 1 ]]; then
  usage >&2
  exit 1
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
  usage
  exit
fi

function init() {
  local params="$1"
  echo ${params}
}

init "$@"
