#!/bin/bash
#
# Unix full post-install script

if [[ -f "$(dirname "$(readlink -f "${0}")")/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "$(dirname "$(readlink -f "${0}")")/.functions"
else
  echo "File does not exist!"
  echo "$(dirname "$(readlink -f "${0}")")/.functions"
  exit "1"
fi

repo_update() {
  # Declare local variables
  local current_script
  local new_script
  local current_checksum
  local new_checksum
  local new_flag
  local return_code

  # Initialize local variables
  current_script="$(realpath "${0}")"
  new_script="${HOME}/.dotfiles/scripts/update.sh"
  current_checksum=""
  new_checksum=""
  new_flag="1"
  return_code="1"

  print_stage "Updating dotfiles repo"

  # Check if GitHub domain is valid and accessible
  abort_check_connectivity "github.com"
  abort_not_installed "git"
  abort_directory_dne "${HOME}/.dotfiles"

  # Compute this install script checksum
  current_checksum="$(checksum_file "${current_script}")"

  # Pull latest repo
  print_step "Updating dotfiles repo"
  git -C "${HOME}/.dotfiles" pull

  # Compute new update script checksum
  new_checksum="$(checksum_file "${new_script}")"

  # Compare this and new install script checksums
  if [[ "${current_script}" == "${new_script}" ]]; then
    if [[ "${current_checksum}" -eq "${new_checksum}" ]]; then
      new_flag="0"
    fi
  fi

  # Check if install script was new or updated
  if [[ "${new_flag}" -ne 0 ]]; then
    # Ensure new install script can execute
    chmod +x "${new_script}"

    # Run new install script
    print_step "Running updated install script"
    "${new_script}"
    return_code="${?}"

    # Delete current install script if no error
    if [[ "${return_code}" -eq 0 ]]; then
      if [[ "${current_script}" != "${new_script}" ]]; then
        print_step "Deleting current install script"
        rm -f "${current_script}"
      fi
    fi

    # Repeat return code and exit
    exit_script "${return_code}"
  fi

  # Set file permissions
  abort_file_dne "${HOME}/.dotfiles/scripts/set_permissions.sh"
  if ! "${HOME}/.dotfiles/scripts/set_permissions.sh"; then
    abort_script "Script ${HOME}/.dotfiles/scripts/set_permissions.sh Failed!"
  fi
}

update_packages() {
  print_step "Update repository information"
  sudo apt update -qq

  print_step "Perform system upgrade"
  sudo apt dist-upgrade -y

  print_step "Installing dependencies"
  sudo apt install -f

  print_step "Cleaning packages"
  sudo apt clean

  print_step "Autocleaning packages"
  sudo apt autoclean

  print_step "Autoremoving & purging packages"
  sudo apt autoremove --purge -y
}

initial_setup() {
  print_stage "Initial setup"

  update_packages

  print_step "Installing repository tool"
  sudo apt install -y --no-install-recommends software-properties-common
}

headless_setup() {
  # Declare local variables
  local package_list

  # Initialize local variables
  package_list=(
    coreutils
    man-db
    sed
    gawk
    file
    tree
    openssh-server
    cron
    zsh
    tmux
    curl
    vim
    nano
    nmap
    htop
    xclip
    apt-utils
    ncdu
  )

  print_stage "Headless applications setup"

  # Check if GitHub domain is valid and accessible
  abort_check_connectivity "github.com"

  # print_step "Adding repositories"

  # Install packages
  for listIndex in "${package_list[@]}"; do
    # Check if package already installed
    if ! dpkg-query -W -f='${Status}' "${listIndex}" 2>/dev/null |
      grep -c "ok installed" &>/dev/null; then
      print_step "Installing ${listIndex}"
      sudo apt install -y --no-install-recommends "${listIndex}"
    else
      print_step "Skipped: Installing ${listIndex}"
    fi
  done

  # Install Tmux Plugin Manager
  git_update "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm" "Tmux Plugin Manager"

  # Install Zinit Framework
  if directory_exists "${HOME}/.zinit"; then
    print_step "Updating zinit"
    # @todo Fix Zinit Updating
    # @body Find a way to fix the zinit self updating and plugin updating in install script.
    # zinit self-update
    # zinit update --parallel
    # zinit delete --clean --yes
  else
    git_update "https://github.com/zdharma/zinit.git" "${HOME}/.zinit/bin" "zinit"
  fi

  print_step "Installing headless application configurations"
  rm -f "${HOME}/.bash_history"
  rm -f "${HOME}/.bash_logout"
  rm -f "${HOME}/.bashrc"

  # Create links
  abort_file_dne "${HOME}/.dotfiles/scripts/create_links.sh"
  if ! "${HOME}/.dotfiles/scripts/create_links.sh" --headless; then
    abort_script "Script ${HOME}/.dotfiles/scripts/create_links.sh Failed!"
  fi
}

desktop_setup() {
  # Declare local variables
  local package_list

  # Initialize local variables
  package_list=(
    libegl1-mesa-dev
    libssl-dev
    gcc
    g++
    make
    cmake
    build-essential
    firefox
    meld
    pkg-config
    libfreetype6-dev
    libfontconfig1-dev
    libxcb-xfixes0-dev
    python3
  )

  print_stage "Desktop applications setup"

  # Check if GitHub domain is valid and accessible
  abort_check_connectivity "github.com"

  # print_step "Adding repositories"

  # Install packages
  for listIndex in "${package_list[@]}"; do
    # Check if package already installed
    if ! dpkg-query -W -f='${Status}' "${listIndex}" 2>/dev/null |
      grep -c "ok installed" &>/dev/null; then
      print_step "Installing ${listIndex}"
      sudo apt install -y --no-install-recommends "${listIndex}"
    else
      print_step "Skipped: Installing ${listIndex}"
    fi
  done

  # Configure Firefox to default browser
  if is_installed "firefox"; then
    if is_installed "xdg-settings"; then
      if [[ "$(xdg-settings get default-web-browser)" != "firefox.desktop" ]]; then
        xdg-settings set default-web-browser firefox.desktop
      fi
    fi
  fi

  # Installis_installed Rustup
  if not_installed "rustup"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  else
    rustup update
  fi

  # Rust environment handling
  if file_exists "${HOME}/.cargo/env"; then
    # shellcheck disable=SC1090
    source "${HOME}/.cargo/env"

    # Add cargo tools to path if not already in the path
    if [[ "${PATH}" != *"${HOME}/.cargo/bin"* ]]; then
      if directory_exists "${HOME}/.cargo/bin"; then
        export PATH="${HOME}/.cargo/bin:${PATH}"
      fi
    fi
  fi

  # @todo Improve Cargo Package Updating
  # @body Find a way to only update cargo packages if outdated, rather than full reinstall.
  # Install Cargo Applications

  # Install Alacritty
  if not_installed "alacritty"; then
    print_step "Installing alacritty"
    cargo install alacritty

    # Create desktop entry
    wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/linux/Alacritty.desktop
    root_copy "${PWD}/Alacritty.desktop" "/usr/local/bin/Alacritty.desktop"
    sudo chmod u=rwx "/usr/local/bin/Alacritty.desktop"
    mkdir -p "${HOME}/.local/share/applications"
    cp "${PWD}/Alacritty.desktop" "${HOME}/.local/share/applications/Alacritty.desktop"
    chmod u=rwx "${HOME}/.local/share/applications/Alacritty.desktop"
    rm -f "${PWD}/Alacritty.desktop"

    wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg
    root_copy "${PWD}/alacritty-term.svg" "/usr/share/pixmaps/Alacritty.svg"
    rm -f "${PWD}/alacritty-term.svg"

    sudo desktop-file-install "/usr/local/bin/Alacritty.desktop"
    sudo update-desktop-database

    # Set as default terminal (Ctrl + Alt + T)
    if is_installed "gsettings"; then
      gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
    fi
  else
    print_step "Skipped: Installing alacritty"
  fi

  # @todo File Manager Installation
  # @body Determine and automate a file manager (like Double Commander) installation.

  # @todo VS Code Installation
  # @body Automate the VS Code installation.

  # @todo VS Code Config and Extensions
  # @body Export VS Code settings and installation of extensions.

  print_step "Installing desktop fonts"

  # Install FiraCode
  if ! find "${HOME}/.local/share/fonts/NerdFonts/Fura Code"* >/dev/null; then
    "${HOME}/.dotfiles/scripts/install_firacode.sh"
  else
    print_step "Skipped: ${HOME}/.dotfiles/scripts/install_firacode.sh"
  fi

  print_step "Installing desktop configurations"

  # Create links
  abort_file_dne "${HOME}/.dotfiles/scripts/create_links.sh"
  if ! "${HOME}/.dotfiles/scripts/create_links.sh" --desktop; then
    abort_script "Script ${HOME}/.dotfiles/scripts/create_links.sh Failed!"
  fi

  # Install term environment
  if file_dne "/usr/share/terminfo/x/xterm-256color-italic" && file_dne "${HOME}/.terminfo/x/xterm-256color-italic"; then
    print_step "Skipped: ${HOME}/.dotfiles/term/xterm-256color-italic.terminfo"
  else
    if file_dne "/usr/share/terminfo/x/xterm-256color-italic"; then
      sudo cp "${HOME}/.dotfiles/term/xterm-256color-italic.terminfo" "/usr/share/terminfo/x/xterm-256color-italic"
      sudo tic "${HOME}/.dotfiles/term/xterm-256color-italic.terminfo"
    fi

    if file_dne "${HOME}/.terminfo/x/xterm-256color-italic"; then
      tic "${HOME}/.dotfiles/term/xterm-256color-italic.terminfo"
    fi

    print_step "Installed ${HOME}/.dotfiles/term/xterm-256color-italic.terminfo"
  fi

  # Create Global Git Config
  # Temporary measure until gitconfig logic is fixed.
  if file_exists "${HOME}/.gitconfig"; then
    print_step "Skipped: ${HOME}/.dotfiles/scripts/create_gitconfig.sh"
  else
    "${HOME}/.dotfiles/scripts/create_gitconfig.sh"
  fi
}

final_setup() {
  print_stage "Final setup"

  update_packages

  if [[ -n "$(${SHELL} -c 'echo "${ZSH_VERSION}"')" ]]; then
    print_step "Skipped: Changing shell to ZSH"
  else
    print_step "Changing shell to ZSH"
    sudo usermod -s "$(command -v -- zsh)" "${USER}"
    env zsh -l
  fi
}

main() {
  # Declare local variables
  local input_arguments
  local argument_flag
  local headless_mode
  local desktop_mode

  # Initialize local variables
  input_arguments="${*}"
  argument_flag="false"
  headless_mode="disabled"
  desktop_mode="disabled"

  # Configure single password prompt at the beginning of the script
  get_sudo

  # Check repo for updates before proceeding
  repo_update

  if variable_set "${input_arguments}"; then
    # Process arguments
    for argument in "${@}"; do
      argument_flag="true"
      if [[ "${argument}" == "-?" || "${argument}" == "--help" ]]; then
        abort_script "Usage:" "  $(script_filename) [options]" "  -?, --help      show list of command-line options" "" "OPTIONS" "  -h, --headless  force enable headless mode" "  -d, --desktop   force enable desktop mode"
      elif [[ "${argument}" == "-h" || "${argument}" == "--headless" ]]; then
        headless_mode="enabled"
      elif [[ "${argument}" == "-d" || "${argument}" == "--desktop" ]]; then
        desktop_mode="enabled"
      else
        abort_script "Invalid Argument!" "" "Usage:" "  $(script_filename) [options]" "  -?, --help      show list of command-line options"
      fi
    done
  fi

  # Determine system type if no arguments given
  if [[ "${argument_flag}" == "false" ]]; then
    if has_display; then
      desktop_mode="enabled"
    fi
    headless_mode="enabled"
  fi

  initial_setup

  if [[ "${argument_flag}" == "false" || "${headless_mode}" == "enabled" ]]; then
    headless_setup
  fi

  if [[ "${desktop_mode}" == "enabled" ]]; then
    desktop_setup
  fi

  final_setup

  # Cleanup single password prompt at the end of the script
  clear_sudo
}

main "${*}"

exit_script "0"
