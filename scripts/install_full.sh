#!/bin/bash
#
# Unix full post-install script

# @todo Improve Printed Text and Prompts
# @body Clean up printed text with better separation of stages and description of what is happening. Better define what the prompts are actually asking.

source "${HOME}/.dotfiles/functions/.functions"

repo_update() {
  # Declare local variables
  local current_script
  local updated_script
  local current_checksum
  local updated_checksum
  local updated_flag
  local return_code

  # Initialize local variables
  current_script="$(realpath "${0}")"
  updated_script="${HOME}/.dotfiles/scripts/install_full.sh"
  current_checksum=""
  updated_checksum=""
  updated_flag="1"
  return_code="1"

  print_stage "Updating dotfiles repo"

  # Check if GitHub domain is valid and accessible
  abort_check_connectivity "github.com"

  abort_is_installed "git"

  abort_directory_exists "${HOME}/.dotfiles"

  # Compute this install script checksum
  current_checksum="$(checksum_file "${current_script}")"

  # Pull latest repo
  print_step "Updating dotfiles repo"
  git -C "${HOME}/.dotfiles" pull

  # Compute new install script checksum
  updated_checksum="$(checksum_file "${updated_script}")"

  # Compare this and new install script checksums
  if [[ "${current_script}" == "${updated_script}" ]]; then
    if [[ "${current_checksum}" -eq "${updated_checksum}" ]]; then
      updated_flag="0"
    fi
  fi

  # Check if install script was new or updated
  if [[ "${updated_flag}" -ne 0 ]]; then
    # Ensure new install script can execute
    chmod +x "${updated_script}"

    # Run new install script
    print_step "Running updated install script"
    "${updated_script}"
    return_code="${?}"

    # Delete current install script if no error
    if [[ "${return_code}" -eq 0 ]]; then
      if [[ "${current_script}" != "${updated_script}" ]]; then
        print_step "Deleting current install script"
        rm -f "${current_script}"
      fi
    fi

    # Repeat return code and exit
    exit_script "${return_code}"
  fi

  # Set file permissions
  abort_file_exists "${HOME}/.dotfiles/scripts/set_permissions.sh"
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
  package_list=( \
    coreutils \
    man-db \
    sed \
    gawk \
    file \
    tree \
    openssh-server \
    cron \
    zsh \
    tmux \
    curl \
    vim \
    nano \
    nmap \
    htop \
    xclip \
    apt-utils \
  )

  print_stage "Headless applications setup"

  # Check if GitHub domain is valid and accessible
  abort_check_connectivity "github.com"

  # print_step "Adding repositories"
  
  # Install packages
  for listIndex in "${package_list[@]}"; do
    # Check if package already installed
    if ! dpkg-query -W -f='${Status}' "${listIndex}" 2> /dev/null \
      | grep -c "ok installed" &> /dev/null; then
      print_step "Installing ${listIndex}"
      sudo apt install -y --no-install-recommends "${listIndex}"
    else
      print_step "Skipped: Installing ${listIndex}"
    fi
  done

  # Install Fd
  is_installed "fd" || "${HOME}/.dotfiles/scripts/install_fd.sh"

  # Install Tmux Plugin Manager
  if directory_exists "${HOME}/.tmux/plugins/tpm"; then
    print_step "Updating Tmux Plugin Manager repo"
    git -C "${HOME}/.tmux/plugins/tpm" pull
  else
    print_step "Cloning Tmux Plugin Manager repo"
    mkdir -p "${HOME}/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  fi

  # Install Fzf
  if directory_exists "${HOME}/.fzf"; then
    print_step "Updating fzf repo"
    git -C "${HOME}/.fzf" pull
  else
    print_step "Cloning fzf repo"
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
  fi
  "${HOME}/.fzf/install" --bin

  print_step "Installing headless shell"
  # Install Oh-My-Zsh Framework
  if directory_exists "${HOME}/.oh-my-zsh"; then
    print_step "Updating Oh-My-Zsh repo"
    git -C "${HOME}/.oh-my-zsh" pull
  else
    print_step "Installing Oh-My-Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
  fi

  # Install Oh-My-Zsh Theme
  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"; then
    print_step "Updating Powerlevel10k repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" pull
  else
    print_step "Cloning Powerlevel10k repo"
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
  fi

  # Install Oh-My-Zsh Plugins
  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate"; then
    print_step "Updating autoupdate repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate" pull
  else
    print_step "Cloning autoupdate repo"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"; then
    print_step "Updating fast-syntax-highlighting repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" pull
  else
    print_step "Cloning fast-syntax-highlighting repo"
    git clone https://github.com/zdharma/fast-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit"; then
    print_step "Updating forgit repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit" pull
  else
    print_step "Cloning forgit repo"
    git clone https://github.com/wfxr/forgit.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-tab"; then
    print_step "Updating fzf-tab repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-tab" pull
  else
    print_step "Cloning fzf-tab repo"
    git clone https://github.com/Aloxaf/fzf-tab.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-tab"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z"; then
    print_step "Updating fzf-z repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z" pull
  else
    print_step "Cloning fzf-z repo"
    git clone https://github.com/andrewferrier/fzf-z.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/per-directory-history"; then
    print_step "Updating per-directory-history repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/per-directory-history" pull
  else
    print_step "Cloning per-directory-history repo"
    git clone https://github.com/jimhester/per-directory-history.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/per-directory-history"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autopair"; then
    print_step "Updating zsh-autopair repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autopair" pull
  else
    print_step "Cloning zsh-autopair repo"
    git clone https://github.com/hlissner/zsh-autopair.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autopair"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-z"; then
    print_step "Updating zsh-z repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-z" pull
  else
    print_step "Cloning zsh-z repo"
    git clone https://github.com/agkozak/zsh-z.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-z"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"; then
    print_step "Updating zsh-autosuggestions repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" pull
  else
    print_step "Cloning zsh-autosuggestions repo"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"; then
    print_step "Updating zsh-completions repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions" pull
  else
    print_step "Cloning zsh-completions repo"
    git clone https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
  fi

  if directory_exists "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"; then
    print_step "Updating zsh-history-substring-search repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" pull
  else
    print_step "Cloning zsh-history-substring-search repo"
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"
  fi

  print_step "Installing headless application configurations"
  rm -f "${HOME}/.bash_history"
  rm -f "${HOME}/.bash_logout"
  rm -f "${HOME}/.bashrc"
  rm -f "${HOME}/.zshrc.pre-oh-my-zsh"

  # Create links
  abort_file_exists "${HOME}/.dotfiles/scripts/create_links.sh"
  if ! "${HOME}/.dotfiles/scripts/create_links.sh" --headless; then
    abort_script "Script ${HOME}/.dotfiles/scripts/create_links.sh Failed!"
  fi
}

desktop_setup() {
  # Declare local variables
  local package_list

  # Initialize local variables
  package_list=( \
    libegl1-mesa-dev \
    libssl-dev \
    gcc \
    g++ \
    make \
    cmake \
    build-essential \
    firefox \
    meld \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    python3 \
  )

  print_stage "Desktop applications setup"

  # Check if GitHub domain is valid and accessible
  abort_check_connectivity "github.com"

  # print_step "Adding repositories"

  # Install packages
  for listIndex in "${package_list[@]}"; do
    # Check if package already installed
    if ! dpkg-query -W -f='${Status}' "${listIndex}" 2> /dev/null \
      | grep -c "ok installed" &> /dev/null; then
      print_step "Installing ${listIndex}"
      sudo apt install -y --no-install-recommends "${listIndex}"
    else
      print_step "Skipped: Installing ${listIndex}"
    fi
  done

  # Install Bat
  is_installed "bat" || "${HOME}/.dotfiles/scripts/install_bat.sh"

  # Install Delta
  is_installed "delta" || "${HOME}/.dotfiles/scripts/install_delta.sh"

  # Install Rustup
  if ! is_installed "rustup"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  else
    rustup update
  fi

  # Rust environment handling
  if file_exists "${HOME}/.cargo/env"; then
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
  if ! is_installed "alacritty"; then
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

  # Install Exa
  if ! is_installed "exa"; then
    print_step "Installing exa"
    cargo install exa
  else
    print_step "Skipped: Installing exa"
  fi

  # @todo File Manager Installation
  # @body Determine and automate a file manager (like Double Commander) installation.

  # @todo Hub Installation
  # @body Determine a non-brew method to install Hub.

  # @todo VS Code Installation
  # @body Automate the VS Code installation.

  # @todo VS Code Config and Extensions
  # @body Export VS Code settings and installation of extensions.

  print_step "Installing desktop fonts"

  # Install FiraCode
  if ! find "${HOME}/.local/share/fonts/NerdFonts/Fura Code"* > /dev/null; then
    "${HOME}/.dotfiles/scripts/install_firacode.sh"
  else
    print_step "Skipped: ${HOME}/.dotfiles/scripts/install_firacode.sh"
  fi

  print_step "Installing desktop configurations"

  # Create links
  abort_file_exists "${HOME}/.dotfiles/scripts/create_links.sh"
  if ! "${HOME}/.dotfiles/scripts/create_links.sh" --desktop; then
    abort_script "Script ${HOME}/.dotfiles/scripts/create_links.sh Failed!"
  fi
  
  # Install term environment
  if ! file_exists "/usr/share/terminfo/x/xterm-256color-italic" && ! file_exists "${HOME}/.terminfo/x/xterm-256color-italic"; then
    print_step "Skipped: ${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
  else
    if ! file_exists "/usr/share/terminfo/x/xterm-256color-italic"; then
      sudo cp "${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo" "/usr/share/terminfo/x/xterm-256color-italic"
      sudo tic "${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
    fi

    if ! file_exists "${HOME}/.terminfo/x/xterm-256color-italic"; then
      tic "${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
    fi

    print_step "Installed ${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
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
    sudo usermod -s "$(which zsh)" "${USER}"
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

  if [[ -n "${input_arguments}" ]]; then
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

  # Check repo for updates before proceeding
  repo_update

  # Configure single password prompt at the beginning of the script
  get_sudo

  # Determine system type if no arguments given
  if [[ "${argument_flag}" == "false" ]]; then
    abort_file_exists "${HOME}/.dotfiles/scripts/is_desktop.sh"
    "${HOME}/.dotfiles/scripts/is_desktop.sh" > /dev/null \
      && desktop_mode="enabled" \
      || headless_mode="enabled"
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
