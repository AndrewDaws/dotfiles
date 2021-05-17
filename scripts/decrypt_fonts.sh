#!/bin/bash
# Decrypts and installs the encrypted fonts
script_name="$(basename "${0}")"

if [[ -f "$(dirname "$(readlink -f "${0}")")/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "$(dirname "$(readlink -f "${0}")")/.functions"
else
  echo "File does not exist!"
  echo "  $(dirname "$(readlink -f "${0}")")/.functions"
  exit "1"
fi

# Install decryption application
if not_installed "git-crypt"; then
  sudo apt install -y --no-install-recommends \
    git-crypt
fi

# Create key directory
if [[ -d "${HOME}/.git-crypt" ]]; then
  mkdir -p "${HOME}/.git-crypt"
  chmod 700 "${HOME}/.git-crypt"
fi

# Attempt to decrypt
echo "=> Decrypting with key"
if [[ -f "${HOME}/.git-crypt/dotfiles.key" ]]; then
  if ! (
    cd "${HOME}/.dotfiles"
    git-crypt unlock "${HOME}/.git-crypt/dotfiles.key"
  ); then
    echo "Aborting ${script_name}"
    echo "  Decrypting ${HOME}/.dotfiles Failed!"
    exit 1
  else
    if [[ -d "${HOME}/.local/share/fonts/DankMono" ]]; then
      echo "Skipped: ${HOME}/.dotfiles/fonts/DankMono.tar"
    else
      tar -xvf "${HOME}/.dotfiles/fonts/DankMono.tar" -C "${HOME}/.local/share/fonts"
      sudo fc-cache -f -v
    fi
    if [[ -d "${HOME}/.local/share/fonts/OperatorMono" ]]; then
      echo "Skipped: ${HOME}/.dotfiles/fonts/OperatorMono.tar"
    else
      tar -xvf "${HOME}/.dotfiles/fonts/OperatorMono.tar" -C "${HOME}/.local/share/fonts"
      sudo fc-cache -f -v
    fi
  fi
else
  echo "Aborting ${script_name}"
  echo "  File ${HOME}/.git-crypt/dotfiles.key Does Not Exist!"
  exit 1
fi

exit 0
