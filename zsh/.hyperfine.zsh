#!/bin/bash
#
# Hyperfine aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

# hyperfine aliases
alias hyperfine="hyperfine -u millisecond -s full -S ${SHELL}"
alias bench="hyperfine"
alias benchmark="hyperfine"