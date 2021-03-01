#!/bin/bash
#
# Nmap aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

# nmap aliases
netscan() {
    echo Starting Nmap scan...
    sudo nmap -sn ${1} | awk '!/Host is up|Starting Nmap|done/{gsub(/[()]/,""); if ("${6}" == "") {print ${5}} else {print ${6} " " ${5}}}'
}
