#!/bin/bash
#
# Hardware configuration installation script

if [[ -f "$(dirname "${0}")/.functions" ]]; then
  # shellcheck disable=SC1090
  source "$(dirname "${0}")/.functions"
else
  echo "File does not exist!"
  echo "$(dirname "${0}")/.functions"
  exit "1"
fi

hwdb_install() {
  # Declare local variables
  local input_file
  local input_filename
  local input_checksum
  local hwdb_directory
  local hwdb_file
  local hwdb_checksum
  local hwdb_application
  local hwdb_command
  local udevadm_application
  local udevadm_command

  # Initialize local variables
  input_file="${*}"
  input_filename=""
  input_checksum=""
  hwdb_directory="/etc/udev/hwdb.d"
  hwdb_file=""
  hwdb_checksum=""
  hwdb_application="systemd-hwdb"
  hwdb_command="${hwdb_application} update"
  udevadm_application="udevadm"
  udevadm_command="${udevadm_application} hwdb --update"

  # Check if input file variable is set
  abort_variable_unset "input_file" "${input_file}"

  # Check if input file is not missing
  abort_file_dne "${input_file}"

  # Check for systemd-hwdb
  abort_not_installed "${hwdb_application}"

  # Check if hwdb directory is not missing
  abort_directory_dne "${hwdb_directory}"

  # Check for udevadm
  abort_not_installed "${udevadm_application}"

  input_filename="$(basename "${input_file}")"
  input_checksum="$(checksum_file "${input_file}")"
  hwdb_file="${hwdb_directory}/${input_filename}"

  # Check if hwdb file already exists
  if file_exists "${hwdb_file}"; then
    hwdb_checksum="$(checksum_file "${hwdb_file}")"
  fi

  if [[ "${input_checksum}" -ne "${hwdb_checksum}" ]]; then
    print_step "Installing hardware configuration ${input_filename}"

    if ! root_copy "${input_file}" "${hwdb_file}"; then
      abort_script "Failed to copy file!" "${input_file}"
    fi

    if ! root_owner "${hwdb_file}"; then
      abort_script "Failed to change file ownership!" "${hwdb_file}"
    fi

    if ! root_command "${hwdb_command}"; then
      abort_script "Failed to execute command!" "${hwdb_command}"
    fi

    if ! root_command "${udevadm_command}"; then
      abort_script "Failed to execute command!" "${udevadm_command}"
    fi
  else
    print_step "Skipped: Installing hardware configuration ${input_filename}"
  fi
}

configure_hardware() {
  hwdb_install "${HOME}/.dotfiles/hardware/70-elecom-deft.hwdb"
  hwdb_install "${HOME}/.dotfiles/hardware/80-elecom-huge.hwdb"

  echo "A system reboot or hardware replug may be required to load any configuration changes"
}

main() {
  # Configure single password prompt at the beginning of the script
  get_sudo

  # Core script execution
  configure_hardware

  # Cleanup single password prompt at the end of the script
  clear_sudo
}

main "${*}"

exit_script "0"
