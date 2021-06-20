# Source: https://gist.githubusercontent.com/oshybystyi/475ee7768efc03727f21/raw/4bfd57ef277f5166f3070f11800548b95a501a19/git-auto-status.plugin.zsh
# default list of git commands `git status` is running after
gitPreAutoStatusCommands=(
    'add'
    'rm'
    'reset'
    'commit'
    'checkout'
    'mv'
    'init'
)

# Aliases
# taken from http://stackoverflow.com/a/8574392/4647743
function elementInArray() {
    local e
    for e in "${@:2}"; do [[ "${e}" == "${1}" ]] && return 0; done
    return 1
}

function git() {
    command git $@

    if (elementInArray ${1} ${gitPreAutoStatusCommands}); then
        command git status
    fi
}
