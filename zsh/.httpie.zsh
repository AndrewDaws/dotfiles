#!/bin/bash
#
# Httpie aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

# httpie aliases
alias dl="http --download"
