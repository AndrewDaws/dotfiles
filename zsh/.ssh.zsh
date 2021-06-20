#!/bin/bash
#
# Ssh aliases

# Ensure this file is only sourced, not executed
if [[ "${BASH_SOURCE[0]}" -ef "${0}" ]]; then
  exit 1
fi

alias ssh="TERM=xterm-256color ssh"
alias scp="scp -p"

ssh_gen() {
  # Declare local variables
  local sshHost
  local sshUser
  local sshKey
  local confirmCopy
  local confirmConfig

  # Initialize local variables
  sshUser=""
  sshHost=""
  sshKey=""
  confirmCopy=""
  confirmConfig=""

  if [[ -n "${2}" ]]; then
    sshUser="${1}"
    sshHost="${2}"
    sshKey="${HOME}/.ssh/${sshHost}-${sshUser}"

    echo "------------------------------------------------------------------------"
    echo "   Creating ssh key ${sshHost}"
    echo "------------------------------------------------------------------------"
    ssh-keygen -t ed25519 -N '' -f "${sshKey}"

    echo "=> Copy public key to ${sshHost}? [Y/N] "
    read confirmCopy
    confirmCopy="$(echo "${confirmCopy}" | tr '[:lower:]' '[:upper:]')"
    if [[ "${confirmCopy}" == 'YES' || "${confirmCopy}" == 'Y' ]]; then
      ssh_copy "${sshUser}" "${sshHost}" "${sshKey}"
    fi

    echo "=> Generate an SSH config? [Y/N] "
    read confirmConfig
    confirmConfig="$(echo "${confirmConfig}" | tr '[:lower:]' '[:upper:]')"
    if [[ "${confirmConfig}" == 'YES' || "${confirmConfig}" == 'Y' ]]; then
      ssh_config "${sshUser}" "${sshHost}"
    fi
  else
    if [[ -n "${1}" ]]; then
      sshHost="${1}"

      ssh-keygen -t ed25519 -N '' -f "${HOME}/.ssh/${sshHost}"
    else
      ssh-keygen
    fi
  fi
}

ssh_copy() {
  # Declare local variables
  local sshHost
  local sshUser
  local sshKey

  # Initialize local variables
  sshUser="${1}"
  sshHost="${2}"
  sshKey="${3}"

  if [[ -n "${sshHost}" ]]; then
    echo "------------------------------------------------------------------------"
    echo "   Copying ssh key ${sshKey}.pub"
    echo "------------------------------------------------------------------------"
    ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no -i "${sshKey}" "${sshUser}@${sshHost}"
  else
    ssh-copy-id
  fi
}

ssh_config() {
  # Declare local variables
  local sshHost
  local sshUser
  local sshAlias

  # Initialize local variables
  sshHost="${2}"
  sshUser="${1}"
  sshAlias=""

  if [[ -n "${sshHost}" ]]; then
    echo "=> What is the alias you would like to configure? "
    read sshAlias
    if [[ -n "${sshAlias}" ]]; then
      echo "------------------------------------------------------------------------"
      echo "   Creating ssh config ${sshUser}@${sshHost}"
      echo "------------------------------------------------------------------------"

      touch "${HOME}/.ssh/config"
      {
        echo ""
        echo "Host ${sshAlias}"
        echo "  HostName ${sshHost}"
        echo "  User ${sshUser}"
        echo "  IdentitiesOnly yes"
        echo "  IdentityFile ${HOME}/.ssh/${sshHost}-${sshUser}"
      } >>"${HOME}/.ssh/config"
    fi
  else
    echo "Incorrect input parameters!"
  fi
}

ssh_perm() {
  if [[ ! -d "${HOME}/.ssh" ]]; then
    mkdir -p "${HOME}/.ssh"
    echo "Created: ${HOME}/.ssh"
  fi

  find "${HOME}/.ssh" -type d -exec chmod 700 {} \;
  find "${HOME}/.ssh" -type d -exec echo "Modified: {} = 700" \;

  find "${HOME}/.ssh" -type f -exec chmod 600 {} \;
  find "${HOME}/.ssh" -type f -exec echo "Modified: {} = 600" \;

  if [[ -f "${HOME}/.ssh/authorized_keys" ]]; then
    chmod 644 "${HOME}/.ssh/authorized_keys"
    echo "Modifed: ${HOME}/.ssh/authorized_keys = 644"
  fi

  if [[ -f "${HOME}/.ssh/known_hosts" ]]; then
    chmod 644 "${HOME}/.ssh/known_hosts"
    echo "Modifed: ${HOME}/.ssh/known_hosts = 644"
  fi

  if [[ -f "${HOME}/.ssh/config" ]]; then
    chmod 644 "${HOME}/.ssh/config"
    echo "Modifed: ${HOME}/.ssh/config = 644"
  fi

  if find "${HOME}/.ssh/"*.pub &>/dev/null; then
    find "${HOME}/.ssh/"*.pub -type f -exec chmod 644 {} \;
    find "${HOME}/.ssh/"*.pub -type f -exec echo "Modified: {} = 644" \;
  fi
}

ssh_password() {
  ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no "${@}"
}

scp_password() {
  scp -o PreferredAuthentications=password -o PubkeyAuthentication=no "${@}"
}

ssh_ignore() {
  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "${@}"
}

scp_ignore() {
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "${@}"
}

ssh_ignore_password() {
  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no "${@}"
}

scp_ignore_password() {
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no "${@}"
}
