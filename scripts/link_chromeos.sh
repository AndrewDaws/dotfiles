#!/bin/bash
# Link shared Chrome OS directories in home directory

exit_script() {
  # Declare local variables
  local return_code

  # Initialize local variables
  return_code="1"

  # Input parameter provided
  if [[ -n "${1}" ]]; then
    # Check against valid return codes
    if [[ "${1}" -eq 0 || "${1}" -eq 1 ]]; then
      # Overwrite return code
      return_code="${1}"
    fi
  fi

  # Exit script with return code
  exit "${return_code}"
}

abort_script() {
  # Declare local variables
  local script_name

  # Initialize local variables
  script_name="$(basename "${0}")"

  # Print error message
  echo "Aborting ${script_name}"

  # Check for error messages
  if [[ -n "${*}" ]]; then
    # Treat each input parameter as a separate line
    for error_msg in "${@}"; do
      echo "  ${error_msg}"
    done
  fi

  # Exit script with error
  exit_script "1"
}

is_chromeos() {
  # Check if current system is Chrome OS
  if [[ -d "/mnt/chromeos" ]]; then
    return 0
  else
    return 1
  fi
}

link_directories() {
  # Link Chrome OS shared directories
  if is_chromeos; then
    find "/mnt/chromeos/MyFiles/" \
      -maxdepth 1 \
      -mindepth 1 \
      -type d \
      -exec ln -s '{}' "${HOME}/" \;
  else
    abort_script "Not a Chrome OS device or no shared directories"
  fi
}

main() {
  link_directories
}

main "${*}"

exit_script "0"
