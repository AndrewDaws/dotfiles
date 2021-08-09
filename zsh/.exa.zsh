# Set default flags
alias exa="\exa \
  --classify \
  --color-scale \
  --color=always \
  --git \
  --icons \
  --time-style=long-iso \
  "

# Aliases
l() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --git-ignore \
        --long \
        -- "${1}"
    elif [[ -d "${1}" ]]; then
      exa \
        --git-ignore \
        --long \
        -- "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --git-ignore \
        --long \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa \
        --git-ignore \
        --long \
        -- *"${1}"*
    fi
  else
    exa \
      --git-ignore \
      --long \
      -- .
  fi
}

la() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --all \
        --long \
        -- "${1}"
    elif [[ -d "${1}" ]]; then
      exa \
        --all \
        --long \
        -- "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --all \
        --long \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa \
        --all \
        --long \
        -- *"${1}"*
    fi
  else
    exa \
      --all \
      --long \
      -- .
  fi
}

lg() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --git-ignore \
        --group \
        --long \
        -- "${1}"
    elif [[ -d "${1}" ]]; then
      exa \
        --git-ignore \
        --group \
        --long \
        -- "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --git-ignore \
        --group \
        --long \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa \
        --git-ignore \
        --group \
        --long \
        -- *"${1}"*
    fi
  else
    exa \
      --git-ignore \
      --group \
      --long \
      -- .
  fi
}

lga() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --all \
        --group \
        --long \
        -- "${1}"
    elif [[ -d "${1}" ]]; then
      exa \
        --all \
        --group \
        --long \
        -- "${1}"/
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --all \
        --group \
        --long \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*
    else
      exa \
        --all \
        --group \
        --long \
        -- *"${1}"*
    fi
  else
    exa \
      --all \
      --group \
      --long \
      -- .
  fi
}

lt() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --git-ignore \
        --long \
        --reverse \
        --sort=newest \
        -- "${1}" | head -10
    elif [[ -d "${1}" ]]; then
      exa \
        --git-ignore \
        --long \
        --reverse \
        --sort=newest \
        -- "${1}"/ | head -10
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --git-ignore \
        --long \
        --reverse \
        --sort=newest \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"* | head -10
    else
      exa \
        --git-ignore \
        --long \
        --reverse \
        --sort=newest \
        -- *"${1}"* | head -10
    fi
  else
    exa \
      --git-ignore \
      --long \
      --reverse \
      --sort=newest \
      -- . | head -10
  fi
}

lta() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --all \
        --long \
        --reverse \
        --sort=newest \
        -- "${1}" | head -10
    elif [[ -d "${1}" ]]; then
      exa \
        --all \
        --long \
        --reverse \
        --sort=newest \
        -- "${1}"/ | head -10
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --all \
        --long \
        --reverse \
        --sort=newest \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"* | head -10
    else
      exa \
        --all \
        --long \
        --reverse \
        --sort=newest \
        -- *"${1}"* | head -10
    fi
  else
    exa \
      --all \
      --long \
      --reverse \
      --sort=newest \
      -- . | head -10
  fi
}

lf() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --git-ignore \
        --long \
        -- "${1}"*(-.)
    elif [[ -d "${1}" ]]; then
      exa \
        --git-ignore \
        --long \
        -- "${1}"/*(-.)
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --git-ignore \
        --long \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*(-.)
    else
      exa \
        --git-ignore \
        --long \
        -- *"${1}"*(-.)
    fi
  else
    exa \
      --git-ignore \
      --long \
      -- *(-.)
  fi
}

lfa() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --all \
        --long \
        -- "${1}"*(D-.)
    elif [[ -d "${1}" ]]; then
      exa \
        --all \
        --long \
        -- "${1}"/*(D-.)
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --all \
        --long \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*(D-.)
    else
      exa \
        --all \
        --long \
        -- *"${1}"*(D-.)
    fi
  else
    exa \
      --all \
      --long \
      -- *(D-.)
  fi
}

ld() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --git-ignore \
        --long \
        --only-dirs \
        -- "${1}"*(-/)
    elif [[ -d "${1}" ]]; then
      exa \
        --git-ignore \
        --long \
        --only-dirs \
        -- "${1}"/*(-/)
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --git-ignore \
        --long \
        --only-dirs \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*(-/)
    else
      exa \
        --git-ignore \
        --long \
        --only-dirs \
        -- *"${1}"*(-/)
    fi
  else
    exa \
      --git-ignore \
      --long \
      --only-dirs \
      -- "${PWD}"
  fi
}

lda() {
  if [[ -n "${1}" ]]; then
    if [[ "${1: -1}" == "/" ]]; then
      exa \
        --all \
        --long \
        --only-dirs \
        -- "${1}"*(D-/)
    elif [[ -d "${1}" ]]; then
      exa \
        --all \
        --long \
        --only-dirs \
        -- "${1}"/*(D-/)
    elif [[ "${1}" =~ "/" ]]; then
      exa \
        --all \
        --long \
        --only-dirs \
        -- "$(dirname "${1}")"/*"$(basename "${1}")"*(D-/)
    else
      exa \
        --all \
        --long \
        --only-dirs \
        -- *"${1}"*(D-/)
    fi
  else
    exa \
      --all \
      --long \
      --only-dirs \
      -- "${PWD}"
  fi
}
