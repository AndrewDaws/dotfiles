#!/bin/bash
# Link shared Chrome OS directories in home directory

if [[ -f "$(dirname "$(readlink -f "${0}")")/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "$(dirname "$(readlink -f "${0}")")/.functions"
else
  echo "File does not exist!"
  echo "  $(dirname "$(readlink -f "${0}")")/.functions"
  exit "1"
fi

is_chromeos() {
  # Check if current system is Chrome OS
  if directory_exists "/mnt/chromeos"; then
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
