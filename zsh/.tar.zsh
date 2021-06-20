#!/bin/bash
#
# Tar aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

ctar() {
    tar -cvzf ${1}.tar.gz ${1}
}

alias untar="tar -xzf"
