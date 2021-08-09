####################
# Logins and Configs
####################
alias src="exec ${SHELL}"
alias cdd="cd "${HOME}/.dotfiles""

# zshrc
alias czsh=""${EDITOR}" "${HOME}/.zshrc""
alias szsh="source "${HOME}/.zshrc""

# zinit
alias uzsh="zinit self-update && zinit update --no-pager --parallel --all && zinit delete --clean --yes"

# alias
alias cali=""${EDITOR}" "${HOME}/.dotfiles/zsh/.alias.zsh""
alias sali="source "${HOME}/.dotfiles/zsh/.alias.zsh""

# powerlevel10k
alias cp10k=""${EDITOR}" "${HOME}/.dotfiles/zsh/.p10k.zsh""
alias sp10k="source "${HOME}/.dotfiles/zsh/.p10k.zsh""

# tmux
alias ctmux="${EDITOR} ${HOME}/.tmux.conf"
alias stmux="source "${HOME}/.tmux.conf""
alias ktmux="pkill -f tmux"
####################
####################

####################
# Dotfiles
####################
alias dotfiles_create_gitconfig="${HOME}/.dotfiles/scripts/create_gitconfig.sh"
alias dotfiles_create_links="${HOME}/.dotfiles/scripts/create_links.sh"
alias dotfiles_decrypt_fonts="${HOME}/.dotfiles/scripts/decrypt_fonts.sh"
alias dotfiles_update="${HOME}/.dotfiles/scripts/update.sh"
alias dotfiles_set_permissions="${HOME}/.dotfiles/scripts/set_permissions.sh"
####################
####################

####################
# Common
####################
# navigation
alias cd..="cd .."
alias cd....="cd ../.."
alias cd/="cd /"

# set default flags
alias ls="\ls \
  --classify \
  --color=always \
  --escape \
  --human-readable \
  --hyperlink=always \
  --literal \
  --no-group \
  --si \
  --time-style=long-iso \
  "
alias cp="\cp \
  --interactive \
  --one-file-system \
  --preserve \
  --recursive \
  --verbose \
  "
alias mv="\mv \
  --interactive \
  --strip-trailing-slashes \
  --verbose \
  "
alias mkdir="\mkdir \
  --parents \
  --verbose \
  "
alias rm="\rm \
  --interactive=once \
  --one-file-system \
  --verbose \
  "
alias grep="\grep \
  --color=always \
  --ignore-case \
  "

unalias -m 'l'
l() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        -l -- "${1}" | sed '/total /d'
    elif [[ -d "${1}" ]]; then
      ls \
        -l -- "${1}"/ | sed '/total /d'
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"* | sed '/total /d'
    else
      ls \
        --directory \
        -l -- *"${1}"* | sed '/total /d'
    fi
  else
    ls \
      -l -- . | sed '/total /d'
  fi
}

unalias -m 'la'
la() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        --almost-all \
        -l -- "${1}" | sed '/total /d'
    elif [[ -d "${1}" ]]; then
      ls \
        --almost-all \
        -l -- "${1}"/ | sed '/total /d'
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"* | sed '/total /d'
    else
      ls \
        --almost-all \
        --directory \
        -l -- *"${1}"* | sed '/total /d'
    fi
  else
    ls \
      --almost-all \
      -l -- . | sed '/total /d'
  fi
}

lg() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      \ls \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        -l -- "${1}" | sed '/total /d'
    elif [[ -d "${1}" ]]; then
      \ls \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        -l -- "${1}"/ | sed '/total /d'
    elif [[ "${1}" =~ "/" ]]; then
      \ls \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        --directory -l -- "$(dirname "${1}")"/*"$(basename "${1}")"* | sed '/total /d'
    else
      \ls \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        --directory -l -- *"${1}"* | sed '/total /d'
    fi
  else
    \ls \
      --classify \
      --color=always \
      --escape \
      --human-readable \
      --literal \
      --si \
      --time-style=long-iso \
      -l -- . | sed '/total /d'
  fi
}

lga() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      \ls \
        --almost-all \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        -l -- "${1}" | sed '/total /d'
    elif [[ -d "${1}" ]]; then
      \ls \
        --almost-all \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        -l -- "${1}"/ | sed '/total /d'
    elif [[ "${1}" =~ "/" ]]; then
      \ls \
        --almost-all \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"* | sed '/total /d'
    else
      \ls \
        --almost-all \
        --classify \
        --color=always \
        --escape \
        --human-readable \
        --literal \
        --si \
        --time-style=long-iso \
        --directory \
        -l -- *"${1}"* | sed '/total /d'
    fi
  else
    \ls \
      --almost-all \
      --classify \
      --color=always \
      --escape \
      --human-readable \
      --literal \
      --si \
      --time-style=long-iso \
      -l -- . | sed '/total /d'
  fi
}

lt() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        -lt -- "${1}" | sed '/total /d' | head -10
    elif [[ -d "${1}" ]]; then
      ls \
        -lt -- "${1}"/ | sed '/total /d' | head -10
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --directory \
        -lt -- "$(dirname "${1}")"/*"$(basename "${1}")"* | sed '/total /d' | head -10
    else
      ls \
        --directory \
        -lt -- *"${1}"* | sed '/total /d' | head -10
    fi
  else
    ls \
      -lt -- . | sed '/total /d' | head -10
  fi
}

lta() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        --almost-all \
        -lt -- "${1}" | sed '/total /d' | head -10
    elif [[ -d "${1}" ]]; then
      ls \
        --almost-all \
        -lt -- "${1}"/ | sed '/total /d' | head -10
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --almost-all \
        --directory \
        -lt -- "$(dirname "${1}")"/*"$(basename "${1}")"* | sed '/total /d' | head -10
    else
      ls \
        --almost-all \
        --directory \
        -lt -- *"${1}"* | sed '/total /d' | head -10
    fi
  else
    ls \
      --almost-all \
      -lt -- . | sed '/total /d' | head -10
  fi
}

lf() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        --directory \
        -l -- "${1}"*(-.)
    elif [[ -d "${1}" ]]; then
      ls \
        --directory \
        -l -- "${1}"/*(-.)
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"*(-.)
    else
      ls \
        --directory \
        -l -- *"${1}"*(-.)
    fi
  else
    ls \
      -l -- *(-.)
  fi
}

lfa() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "${1}"*(D-.)
    elif [[ -d "${1}" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "${1}"/*(D-.)
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"*(D-.)
    else
      ls \
        --almost-all \
        --directory \
        -l -- *"${1}"*(D-.)
    fi
  else
    ls \
      --almost-all \
      -l -- *(D-.)
  fi
}

ld() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        --directory \
        -l -- "${1}"*(-/)
    elif [[ -d "${1}" ]]; then
      ls \
        --directory \
        -l -- "${1}"/*(-/)
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"*(-/)
    else
      ls \
        --directory \
        -l -- *"${1}"*(-/)
    fi
  else
    ls \
      --directory \
      -l -- *(-/)
  fi
}

lda() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "${1}"*(D-/)
    elif [[ -d "${1}" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "${1}"/*(D-/)
    elif [[ "${1}" =~ "/" ]]; then
      ls \
        --almost-all \
        --directory \
        -l -- "$(dirname "${1}")"/*"$(basename "${1}")"*(D-/)
    else
      ls \
        --almost-all \
        --directory \
        -l -- *"${1}"*(D-/)
    fi
  else
    ls \
      --almost-all \
      --directory \
      -l -- *(D-/)
  fi
}

alias pa="ps -af"

alias font_refresh="sudo fc-cache -f -v"
####################
####################

# @todo Distro Package Manager Aliases
# @body Create package manager aliases for other distro (fedora, alpine, etc) package managers.
####################
# Package Managers
####################
# apt
# shellcheck disable=SC1090
command -v -- "apt" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.apt.zsh" ]] && source "${HOME}/.dotfiles/zsh/.apt.zsh"

# dpkg
# shellcheck disable=SC1090
command -v -- "dpkg" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.dpkg.zsh" ]] && source "${HOME}/.dotfiles/zsh/.dpkg.zsh"

# pip
# shellcheck disable=SC1090
command -v -- "pip3" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.pip.zsh" ]] && source "${HOME}/.dotfiles/zsh/.pip.zsh"

# gem
# shellcheck disable=SC1090
command -v -- "gem" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.gem.zsh" ]] && source "${HOME}/.dotfiles/zsh/.gem.zsh"
####################
####################

####################
# Applications
####################
# chrome
# shellcheck disable=SC1090
command -v -- "google-chrome" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.chrome.zsh" ]] && source "${HOME}/.dotfiles/zsh/.chrome.zsh"

# exa
# shellcheck disable=SC1090
# command -v -- "exa" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.exa.zsh" ]] && source "${HOME}/.dotfiles/zsh/.exa.zsh"

# git
# shellcheck disable=SC1090
command -v -- "git" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.git.zsh" ]] && source "${HOME}/.dotfiles/zsh/.git.zsh"

# httpie
# shellcheck disable=SC1090
command -v -- "http" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.httpie.zsh" ]] && source "${HOME}/.dotfiles/zsh/.httpie.zsh"

# hub
# shellcheck disable=SC1090
#command -v -- "hub" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.hub.zsh" ]] && source "${HOME}/.dotfiles/zsh/.hub.zsh"

# hyperfine
# shellcheck disable=SC1090
command -v -- "hyperfine" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.hyperfine.zsh" ]] && source "${HOME}/.dotfiles/zsh/.hyperfine.zsh"

# nmap
# shellcheck disable=SC1090
command -v -- "nmap" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.nmap.zsh" ]] && source "${HOME}/.dotfiles/zsh/.nmap.zsh"

# ssh
# shellcheck disable=SC1090
command -v -- "ssh" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.ssh.zsh" ]] && source "${HOME}/.dotfiles/zsh/.ssh.zsh"

# vim
# shellcheck disable=SC1090
command -v -- "vim" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.vim.zsh" ]] && source "${HOME}/.dotfiles/zsh/.vim.zsh"

# vscode
# shellcheck disable=SC1090
command -v -- "code" &>/dev/null && [[ -f "${HOME}/.dotfiles/zsh/.vscode.zsh" ]] && source "${HOME}/.dotfiles/zsh/.vscode.zsh"
####################
####################
