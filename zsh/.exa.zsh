# Set default flags
alias exa="exa --color=always --color-scale --git --time-style=long-iso --classify --icons"

# Aliases
l() {
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

la() {
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

lg() {
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

lga() {
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

lt() {
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

lta() {
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

lf() {
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

lfa() {
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

ld() {
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

lda() {
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
