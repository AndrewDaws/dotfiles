#!/bin/bash
#
# Hardware configuration installation script

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

script_filename() {
  # Declare local variables
  local output_filename

  # Initialize local variables
  output_filename="$(basename "${0}")"

  # Return script filename
  echo "${output_filename}"
}

variable_set() {
  # Declare local variables
  local input_variable

  # Initialize local variables
  input_variable="${1}"

  # Returns 0 if variable is set or error if it is not
  if [[ -n "${input_variable}" ]]; then
    return 0
  else
    return 1
  fi
}

variable_unset() {
  # Declare local variables
  local input_variable

  # Initialize local variables
  input_variable="${*}"

  # Returns 0 if variable is unset or error if it is not
  if [[ -z "${input_variable}" ]]; then
    return 0
  else
    return 1
  fi
}

file_exists() {
  # Declare local variables
  local input_file

  # Initialize local variables
  input_file="${*}"

  # Returns 0 if file exists or error if it does not
  if [[ -f "${input_file}" ]]; then
    return 0
  else
    return 1
  fi
}

file_full() {
  # Declare local variables
  local input_file

  # Initialize local variables
  input_file="${*}"

  # Returns 0 if file is full or error if it is not
  if [[ -s "${input_file}" ]]; then
    return 0
  else
    return 1
  fi
}

directory_exists() {
  # Declare local variables
  local input_directory

  # Initialize local variables
  input_directory="${*}"

  # Returns 0 if directory exists or error if it does not
  if [[ -d "${input_directory}" ]]; then
    return 0
  else
    return 1
  fi
}

path_exists() {
  # Declare local variables
  local input_path

  # Initialize local variables
  input_path="${*}"

  # Returns 0 if path exists or error if it does not
  if [[ -e "${input_path}" ]]; then
    return 0
  else
    return 1
  fi
}

is_installed() {
  # Declare local variables
  local input_application

  # Initialize local variables
  input_application="${1}"

  # Returns 0 if application is installed or error if it is not
  if which "${input_application}" | grep -o "${input_application}" > /dev/null; then
    return 0
  else
    return 1
  fi
}

is_root() {
  # Check if current user is root
  if [[ "${EUID}" -eq 0 ]]; then
    return 0
  else
    return 1
  fi
}

print_stage() {
  # Check for input messages
  if [[ -n "${*}" ]]; then
    # Print header
    echo "------------------------------------------------------------------------"

    # Treat each input parameter as a separate line
    for message_line in "${@}"; do
      echo "   ${message_line}"
    done

    # Print footer
    echo "------------------------------------------------------------------------"
  fi
}

print_step() {
  # Declare local variables
  local message_count

  # Initialize local variables
  message_count="0"

  # Check for input messages
  if [[ -n "${*}" ]]; then
    # Treat each input parameter as a separate line
    for message_line in "${@}"; do
      # Increment message counter
      message_count="$((message_count+1))"

      # Format based on message count
      if [[ "${message_count}" -eq 1 ]]; then
        echo "=> ${message_line}"
      else
        echo "   ${message_line}"
      fi
    done
  fi
}

abort_script() {
  # Declare local variables
  local calling_function

  # Initialize local variables
  calling_function="${FUNCNAME[1]}"

  # Replace calling function name when helper function used
  if [[ "${calling_function}" == "abort_*" ]]; then
    calling_function="${FUNCNAME[2]}"
  fi

  # Print error message
  echo ""
  print_stage "Aborting execution of $(script_filename)"
  echo "Error in function ${calling_function}:"
  
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

abort_variable_set() {
  # Declare local variables
  local input_name
  local input_variable

  # Initialize local variables
  input_name="${1}"
  input_variable="${2}"

  # Check if input variable is set
  if ! variable_set "${input_variable}"; then
    abort_script "Variable is not set!" "${input_name}"
  fi
}

abort_variable_unset() {
  # Declare local variables
  local input_name
  local input_variable

  # Initialize local variables
  input_name="${1}"
  input_variable="${2}"

  # Check if input variable is unset
  if ! variable_unset "${input_variable}"; then
    abort_script "Variable is not unset!" "${input_name}"
  fi
}

abort_file_exists() {
  # Declare local variables
  local input_file

  # Initialize local variables
  input_file="${*}"

  # Check if input file exists
  if ! file_exists "${input_file}"; then
    abort_script "File does not exist!" "${input_file}"
  fi
}

abort_file_full() {
  # Declare local variables
  local input_file

  # Initialize local variables
  input_file="${*}"

  # Check if input file is full
  if ! file_full "${input_file}"; then
    abort_script "File is empty!" "${input_file}"
  fi
}

abort_directory_exists() {
  # Declare local variables
  local input_directory

  # Initialize local variables
  input_directory="${*}"

  # Check if input directory exists
  if ! directory_exists "${input_directory}"; then
    abort_script "Directory does not exist!" "${input_directory}"
  fi
}

abort_path_exists() {
  # Declare local variables
  local input_path

  # Initialize local variables
  input_path="${*}"

  # Check if input path exists
  if ! path_exists "${input_path}"; then
    abort_script "Path does not exist!" "${input_path}"
  fi
}

abort_is_installed() {
  # Declare local variables
  local input_application

  # Initialize local variables
  input_application="${*}"

  # Check if input application is not installed
  if ! is_installed "${input_application}"; then
    abort_script "Application not installed!" "${input_application}"
  fi
}

sudoers_filename() {
  # Declare local variables
  local output_filename

  # Initialize local variables
  output_filename="${USER}-$(script_filename)"

  # Return sudoers filename
  echo "${output_filename}"
}

sudoers_directory() {
  # Declare local variables
  local output_directory

  # Initialize local variables
  output_directory="/etc/sudoers.d"

  # Return sudoers directory
  echo "${output_directory}"
}

sudoers_filepath() {
  # Declare local variables
  local output_filepath

  # Initialize local variables
  output_filepath="$(sudoers_directory)/$(sudoers_filename)"

  # Return sudoers filepath
  echo "${output_filepath}"
}

has_sudoers() {
  # Check for the existence of the temporary sudoers file
  if directory_exists "$(sudoers_directory)"; then
    if file_exists "$(sudoers_filepath)"; then
      if file_full "$(sudoers_filepath)"; then
        return 0
      else
        return 1
      fi
    else
      return 1
    fi
  else
    return 1
  fi
}

add_sudoers() {
  # Create temporary sudoers file
  echo "$USER $(hostname) = NOPASSWD: $(which tee) $(which apt-get) $(which apt) $(which cp) $(which usermod) $(which chmod) $(which desktop-file-install) $(which update-desktop-database) $(which systemd-hwdb)" \
    | sudo tee "$(sudoers_filepath)" > /dev/null
  if [[ "${?}" -ne 0 ]]; then
    return 1
  fi
}

remove_sudoers() {
  # Remove temporary sudoers file
  sudo "$(which rm)" "$(sudoers_filepath)"
  if [[ "${?}" -ne 0 ]]; then
    return 1
  fi

  # Invalidate cached user credentials
  sudo -k
  if [[ "${?}" -ne 0 ]]; then
    return 1
  fi
}

get_sudo() {
  if ! is_root; then
    if ! add_sudoers; then
      abort_script "Failed to add sudo permissions!"
    fi
  fi
}

clear_sudo() {
  if ! is_root; then
    if has_sudoers; then
      if ! remove_sudoers; then
        abort_script "Failed to remove sudo permissions!" "Please manually delete file" "$(sudoers_filepath)"
      fi
    fi
  fi
}

root_command() {
  # Declare local variables
  local input_command

  # Initialize local variables
  input_command="${*}"

  # Check if input file variable is set
  if [[ -z "${input_command}" ]]; then
    # Error finding input file
    abort_script "Variable not set!" "input_command"
  fi

  # Copy input file as as root
  if is_root; then
    ${input_command}
    if [[ "${?}" -ne 0 ]]; then
      return 1
    fi
  else
    sudo ${input_command}
    if [[ "${?}" -ne 0 ]]; then
      return 1
    fi
  fi
}

root_copy() {
  # Declare local variables
  local input_file
  local output_file

  # Initialize local variables
  input_file="${1}"
  output_file="${2}"

  # Check if input file variable is set
  abort_variable_set "input_file" "${input_file}"

  # Check if input file is not missing
  abort_file_exists "${input_file}"

  # Check if output file variable is set
  abort_variable_set "output_file" "${output_file}"

  # Copy input file as as root
  if is_root; then
    cp -f "${input_file}" "${output_file}"
    if [[ "${?}" -ne 0 ]]; then
      return 1
    fi
  else
    sudo cp -f "${input_file}" "${output_file}"
    if [[ "${?}" -ne 0 ]]; then
      return 1
    fi
  fi
}

root_owner() {
  # Declare local variables
  local input_path

  # Initialize local variables
  input_path="${*}"

  # Check if input path variable is set
  abort_variable_set "input_path" "${input_path}"

  # Check if input path is not missing
  abort_path_exists "${input_path}"

  # Set input path owner to root
  if is_root; then
    chown root:root "${input_path}"
    if [[ "${?}" -ne 0 ]]; then
      return 1
    fi
  
  else
    sudo chown root:root "${input_path}"
    if [[ "${?}" -ne 0 ]]; then
      return 1
    fi
  fi
}

checksum_file() {
  # Declare local variables
  local input_file
  local computed_checksum

  # Initialize local variables
  input_file="${*}"
  computed_checksum=""

  # Check if input file variable is set
  abort_variable_set "input_file" "${input_file}"

  # Check if input file is not missing
  abort_file_exists "${input_file}"

  # Check if input file is not empty
  abort_file_full "${input_file}"

  # Calculate checksum
  computed_checksum="$(cksum "${input_file}" | cut -d' ' -f1)"

  # Return calculation result
  echo "${computed_checksum}"
}

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

  # Initialize local variables
  input_file="${*}"
  input_filename=""
  input_checksum=""
  hwdb_directory="/etc/udev/hwdb.d"
  hwdb_file=""
  hwdb_checksum=""
  hwdb_application="systemd-hwdb"
  hwdb_command="${hwdb_application} update"

  # Check if input file variable is set
  abort_variable_set "input_file" "${input_file}"

  # Check if input file is not missing
  abort_file_exists "${input_file}"

  # Check for systemd-hwdb
  abort_is_installed "${hwdb_application}"

  # Check if hwdb directory is not missing
  abort_directory_exists "${hwdb_directory}"

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
