#!/bin/bash
#
# WA7 Fireflies configuration script

if [[ -f "$(dirname "$(readlink -f "${0}")")/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "$(dirname "$(readlink -f "${0}")")/.functions"
else
  echo "File does not exist!"
  echo "  $(dirname "$(readlink -f "${0}")")/.functions"
  exit "1"
fi

configure_udev() {
  # Declare local variables
  local input_file
  local input_filename
  local input_checksum
  local udev_directory
  local udev_file
  local udev_checksum
  local udev_application
  local udev_reload
  local udev_trigger

  # Initialize local variables
  input_file="${1}"
  input_filename=""
  input_checksum=""
  udev_directory="/etc/udev/rules.d"
  udev_file=""
  udev_checksum=""
  udev_application="udevadm"
  udev_reload="${udev_application} control --reload-rules"
  udev_trigger="${udev_application} trigger"

  # Check if variable is set
  abort_variable_unset "input_file" "${input_file}"

  # Check if file exists
  abort_file_dne "${input_file}"

  # Check if directory exists
  abort_directory_dne "${udev_directory}"

  # Check if application is installed
  abort_not_installed "${udev_application}"

  # Set paths
  input_filename="$(basename "${input_file}")"
  input_checksum="$(checksum_file "${input_file}")"
  udev_file="${udev_directory}/${input_filename}"

  # Check if rules file already exists
  if file_exists "${udev_file}"; then
    udev_checksum="$(checksum_file "${udev_file}")"
  fi

  # Avoid re-install if no change
  if [[ "${input_checksum}" -ne "${udev_checksum}" ]]; then
    print_step "Installing udev rules"

    # Copy rules file
    if ! root_copy "${input_file}" "${udev_file}"; then
      abort_script "Failed to copy file!" "${input_file}"
    fi

    # Set rules file owner
    if ! root_owner "${udev_file}"; then
      abort_script "Failed to change file ownership!" "${udev_file}"
    fi

    # Reload rules
    if ! root_command "${udev_reload}"; then
      abort_script "Failed to execute command!" "${udev_reload}"
    fi

    # Restart udev
    if ! root_command "${udev_trigger}"; then
      abort_script "Failed to execute command!" "${udev_trigger}"
    fi
  else
    print_step "Skipped: Installing udev rules"
  fi
}

configure_pulse() {
  # Declare local variables
  local input_daemonfile
  local input_defaultfile
  local pulse_directory
  local pulse_daemonfile
  local pulse_defaultfile
  local pulse_application
  local pulse_restart
  local install_daemon
  local install_default

  # Initialize local variables
  input_daemonfile="${1}"
  input_defaultfile="${2}"
  pulse_directory="/etc/pulse"
  pulse_daemonfile="${pulse_directory}/daemon.conf"
  pulse_defaultfile="${pulse_directory}/default.pa"
  pulse_application="pulseaudio"
  pulse_restart="${pulse_application} --kill"
  install_daemon="true"
  install_default="true"

  # Check if variable is set
  abort_variable_unset "input_daemonfile" "${input_daemonfile}"
  abort_variable_unset "input_defaultfile" "${input_defaultfile}"

  # Check if file exists
  abort_file_dne "${input_daemonfile}"
  abort_file_dne "${input_defaultfile}"

  # Check if pulse is installed
  if is_installed "${pulse_application}"; then
    # Check if directory exists
    abort_directory_dne "${pulse_directory}"

    # Check if file exists
    abort_file_dne "${pulse_daemonfile}"
    abort_file_dne "${pulse_defaultfile}"

    # Check if daemon already configured
    if line_exists "${pulse_daemonfile}" "$(head -1 "${input_daemonfile}")"; then
      install_daemon="false"
    fi

    # Check if default already configured
    if line_exists "${pulse_defaultfile}" "$(head -1 "${input_defaultfile}")"; then
      install_default="false"
    fi

    # Avoid re-install if no change
    if [[ "${install_daemon}" == "false" && "${install_default}" == "false" ]]; then
      print_step "Skipped: Installing pulse configs"
    else
      print_step "Installing pulse configs"

      # Install daemon
      if [[ "${install_daemon}" == "true" ]]; then
        # Check if root
        if is_root; then
          # Append to daemon file
          if ! tee --append "${pulse_daemonfile}" <"${input_daemonfile}" &>"/dev/null"; then
            abort_script "Failed to execute command!" \
              "tee --append \"${pulse_daemonfile}\" <\"${input_daemonfile}\" &>\"/dev/null\""
          fi
        else
          # Append to daemon file
          # shellcheck disable=SC2024
          if ! sudo tee --append "${pulse_daemonfile}" <"${input_daemonfile}" &>"/dev/null"; then
            abort_script "Failed to execute command!" \
              "sudo tee --append \"${pulse_daemonfile}\" <\"${input_daemonfile}\" &>\"/dev/null\""
          fi
        fi
      fi

      # Install default
      if [[ "${install_default}" == "true" ]]; then
        # Check if root
        if is_root; then
          # Append to default file
          if ! tee --append "${pulse_defaultfile}" <"${input_defaultfile}" &>"/dev/null"; then
            abort_script "Failed to execute command!" \
              "tee --append \"${pulse_defaultfile}\" <\"${input_defaultfile}\" &>\"/dev/null\""
          fi
        else
          # Append to default file
          # shellcheck disable=SC2024
          if ! sudo tee --append "${pulse_defaultfile}" <"${input_defaultfile}" &>"/dev/null"; then
            abort_script "Failed to execute command!" \
              "sudo tee --append \"${pulse_defaultfile}\" <\"${input_defaultfile}\" &>\"/dev/null\""
          fi
        fi
      fi

      # Restart pulse
      if ! ${pulse_restart}; then
        abort_script "Failed to execute command!" "${pulse_restart}"
      fi
    fi
  else
    print_step "Skipped: Installing pulse configs"
  fi
}

main() {
  # Configure single password prompt at the beginning of the script
  get_sudo

  # Core script execution
  configure_udev "${HOME}/.dotfiles/udev/85-wa7-fireflies.rules"
  configure_pulse "${HOME}/.dotfiles/pulse/wa7_fireflies.conf" "${HOME}/.dotfiles/pulse/wa7_fireflies.pa"
  echo "A system reboot or hardware replug may be required to load any configuration changes"

  # Cleanup single password prompt at the end of the script
  clear_sudo
}

main "${*}"

exit_script "0"
