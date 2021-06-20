#!/bin/bash
#
# Exa aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

# set default flags
alias exa="exa --color=always --color-scale --git --time-style=long-iso -F --icons"

e() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa --git-ignore -l "${1}"
    elif [[ -d "${1}" ]]; then
      exa --git-ignore -l "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa --git-ignore -ld "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa --git-ignore -ld *"${1}"*
    fi
  else
    exa --git-ignore -l .
  fi
}

ea() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa -la "${1}"
    elif [[ -d "${1}" ]]; then
      exa -la "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa -lad "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa -lad *"${1}"*
    fi
  else
    exa -la .
  fi
}

eg() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa --git-ignore -lg "${1}"
    elif [[ -d "${1}" ]]; then
      exa --git-ignore -lg "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa --git-ignore -lgd "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa --git-ignore -lgd *"${1}"*
    fi
  else
    exa --git-ignore -lg .
  fi
}

ega() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa -lga "${1}"
    elif [[ -d "${1}" ]]; then
      exa -lga "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa -lgad "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa -lgad *"${1}"*
    fi
  else
    exa -lga .
  fi
}

et() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa --git-ignore --sort=newest -lr -- "${1}" | head -10
    elif [[ -d "${1}" ]]; then
      exa --git-ignore --sort=newest -lr -- "${1}"/ | head -10
    elif [[ "${1}" =~ "/" ]]; then
      exa --git-ignore --sort=newest -lrd -- "$(dirname "${1}")"/*"$(basename "${1}")"* | head -10
    else
      exa --git-ignore --sort=newest -lrd -- *"${1}"* | head -10
    fi
  else
    exa --git-ignore --sort=newest -lr -- . | head -10
  fi
}

eta() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa --sort=newest -lra -- "${1}" | head -10
    elif [[ -d "${1}" ]]; then
      exa --sort=newest -lra -- "${1}"/ | head -10
    elif [[ "${1}" =~ "/" ]]; then
      exa --sort=newest -lrad -- "$(dirname "${1}")"/*"$(basename "${1}")"* | head -10
    else
      exa --sort=newest -lrad -- *"${1}"* | head -10
    fi
  else
    exa --sort=newest -lra -- . | head -10
  fi
}

ef() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa --git-ignore -ld -- "${1}"*(-.)
    elif [[ -d "${1}" ]]; then
      exa --git-ignore -ld -- "${1}"/*(-.)
    elif [[ "${1}" =~ "/" ]]; then
      exa --git-ignore -ld -- "$(dirname "${1}")"/*"$(basename "${1}")"*(-.)
    else
      exa --git-ignore -ld -- *"${1}"*(-.)
    fi
  else
    exa --git-ignore -l -- *(-.)
  fi
}

efa() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa -lad -- "${1}"*(D-.)
    elif [[ -d "${1}" ]]; then
      exa -lad -- "${1}"/*(D-.)
    elif [[ "${1}" =~ "/" ]]; then
      exa -lad -- "$(dirname "${1}")"/*"$(basename "${1}")"*(D-.)
    else
      exa -lad -- *"${1}"*(D-.)
    fi
  else
    exa -la -- *(D-.)
  fi
}

ed() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa --git-ignore -ld -- "${1}"*(-/)
    elif [[ -d "${1}" ]]; then
      exa --git-ignore -ld -- "${1}"/*(-/)
    elif [[ "${1}" =~ "/" ]]; then
      exa --git-ignore -ld -- "$(dirname "${1}")"/*"$(basename "${1}")"*(-/)
    else
      exa --git-ignore -ld -- *"${1}"*(-/)
    fi
  else
    exa --git-ignore -ld -- *(-/)
  fi
}

eda() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa -lad -- "${1}"*(D-/)
    elif [[ -d "${1}" ]]; then
      exa -lad -- "${1}"/*(D-/)
    elif [[ "${1}" =~ "/" ]]; then
      exa -lad -- "$(dirname "${1}")"/*"$(basename "${1}")"*(D-/)
    else
      exa -lad -- *"${1}"*(D-/)
    fi
  else
    exa -lad -- *(D-/)
  fi
}

# override ls aliases
alias l="e"
alias la="ea"
alias lg="eg"
alias lga="ega"
alias lt="et"
alias lta="eta"
alias lf="ef"
alias lfa="efa"
alias ld="ed"
alias lda="eda"
