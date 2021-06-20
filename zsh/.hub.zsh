#!/bin/bash
#
# Hub aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

alias git="hub"

# Source: https://gist.githubusercontent.com/oshybystyi/475ee7768efc03727f21/raw/4bfd57ef277f5166f3070f11800548b95a501a19/git-auto-status.plugin.zsh
# default list of git commands `git status` is running after
hubPreAutoStatusCommands=(
    'add'
    'rm'
    'reset'
    'commit'
    'checkout'
    'mv'
    'init'
)

# taken from http://stackoverflow.com/a/8574392/4647743
function elementInArray() {
    local e
    for e in "${@:2}"; do [[ "${e}" == "${1}" ]] && return 0; done
    return 1
}

function hub() {
    command hub $@

    if (elementInArray ${1} ${hubPreAutoStatusCommands}); then
        command hub status
    fi
}
