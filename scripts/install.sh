#!/bin/bash
#
# Unix post-install script
#
# Author:
#   Andrew Daws
#
# Description:
#   A post-installation bash script for Unix systems
#
# Usage:
#   $ wget https://raw.githubusercontent.com/AndrewDaws/dotfiles/master/scripts/install.sh
#   $ chmod +x install.sh
#   $ ./install.sh
#

# @todo Test Barebones Repo Setup
# @body Test and debug repo setup function for brand new installs that do not have the helper functions.
repo_setup() {
  # Declare local variables
  local input_arguments
  local current_script
  local new_script
  local update_script
  local return_code

  # Initialize local variables
  input_arguments="${*}"
  current_script="$(realpath "${0}")"
  new_script="${HOME}/.dotfiles/scripts/install.sh"
  update_script="${HOME}/.dotfiles/scripts/update.sh"
  return_code="1"

  echo "------------------------------------------------------------------------"
  echo "   Preparing dotfiles repo"
  echo "------------------------------------------------------------------------"

  if ! command -v -- "ping" &>/dev/null; then
    echo ""
    echo "------------------------------------------------------------------------"
    echo "   Aborting execution of $(basename "${0}")"
    echo "------------------------------------------------------------------------"
    echo "Error in function ${FUNCNAME[1]}:"
    echo "  Application not installed!"
    echo "  ping"
    exit 1
  fi

  # Check if GitHub domain is valid and accessible
  if ! ping \
    -c "1" \
    "github.com" \
    &>/dev/null; then
    echo ""
    echo "------------------------------------------------------------------------"
    echo "   Aborting execution of $(basename "${0}")"
    echo "------------------------------------------------------------------------"
    echo "Error in function ${FUNCNAME[1]}:"
    echo "  Failed to connect to address!"
    echo "  github.com"
    exit 1
  fi

  if ! command -v -- "git" &>/dev/null; then
    echo ""
    echo "------------------------------------------------------------------------"
    echo "   Aborting execution of $(basename "${0}")"
    echo "------------------------------------------------------------------------"
    echo "Error in function ${FUNCNAME[1]}:"
    echo "  Application not installed!"
    echo "  git"
    exit 1
  fi

  if [[ ! -d "${HOME}/.dotfiles" ]]; then
    echo "=> Cloning dotfiles repo"
    if ! git clone https://github.com/AndrewDaws/dotfiles.git "${HOME}/.dotfiles"; then
      echo ""
      echo "------------------------------------------------------------------------"
      echo "   Aborting execution of $(basename "${0}")"
      echo "------------------------------------------------------------------------"
      echo "Error in function ${FUNCNAME[1]}:"
      echo "  Failed to clone repo!"
      echo "  https://github.com/AndrewDaws/dotfiles.git"
      exit 1
    fi
  fi

  # Ensure new install script can execute
  chmod +x "${new_script}"
  chmod +x "${update_script}"

  # Run new install script
  echo "=> Running updated install script"
  "${new_script}" "${input_arguments}"
  return_code="${?}"

  # Delete current install script if no error
  if [[ "${return_code}" -eq 0 ]]; then
    if [[ "${current_script}" != "${new_script}" ]]; then
      echo "=> Deleting current install script"
      rm -f "${current_script}"
    fi
  fi

  # Repeat return code and exit
  exit "${return_code}"
}

full_install() {
  # Declare local variables
  local input_arguments
  local return_code

  # Initialize local variables
  input_arguments="${*}"
  return_code="1"

  # Execute update script
  "${HOME}/.dotfiles/scripts/update.sh" "${input_arguments}"
  return_code="${?}"

  # Repeat return code and exit
  exit "${return_code}"
}

main() {
  # Declare local variables
  local input_arguments

  # Initialize local variables
  input_arguments="${*}"

  # Check if update script is available
  if [[ -f "${HOME}/.dotfiles/scripts/update.sh" ]]; then
    # Use update script for newly cloned or previously existing installs
    full_install "${input_arguments}"
  else
    # Fall back on core repo setup
    repo_setup "${input_arguments}"
  fi
}

main "${*}"

exit 0
