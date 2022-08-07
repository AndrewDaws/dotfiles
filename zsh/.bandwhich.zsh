# Aliases

bandwhich() {
  # Check if not run as root
  if ((EUID != 0)); then
    sudo "$(command -- which bandwhich)" "${@}"
  else
    command -- bandwhich "${@}"
  fi
}

ntop() {
  # Check if not run as root
  if ((EUID != 0)); then
    sudo "$(command -- which bandwhich)" "${@}"
  else
    command -- bandwhich "${@}"
  fi
}
