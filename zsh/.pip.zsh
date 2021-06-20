#!/bin/bash
#
# Pip aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

# @todo Pip vs Pip3 Detection
# @body Detect if normal pip or pip3 is installed, and create generic alias(es) for one or both.
#alias pip="pip3"
alias py_inst="pip3 install"
alias py_uninst="pip3 uninstall"
alias py_updt="pip3 freeze — local | grep -v ‘^\-e’ | cut -d = -f 1 | xargs -n1 pip3 install -U"
