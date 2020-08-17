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

# @todo Improve Printed Text and Prompts
# @body Clean up printed text with better separation of stages and description of what is happening. Better define what the prompts are actually asking.

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

  # Exit script with return code
  exit 1
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

is_installed() {
  # Returns 0 if application is installed or error if it is not
  if which "${1}" | grep -o "${1}" > /dev/null; then
    return 0
  else
    return 1
  fi
}

check_connectivity() {
  # Declare local variables
  local test_ip
  local test_count

  # Initialize local variables
  test_count="1"
  if [[ -n "${1}" ]]; then
    test_ip="${1}"
  else
    test_ip="8.8.8.8"
  fi

  is_installed "ping" || sudo apt install -y --no-install-recommends iputils-ping

  # Test connectivity
  if ping -c "${test_count}" "${test_ip}" &> /dev/null; then
    return 0
  else
    return 1
  fi
 }

repo_setup() {
  print_stage "Preparing dotfiles repo"

  # Check internet connectivity
  if ! check_connectivity; then
    # Error checking internet connectivity
    abort_script "No internet connection!"
  fi

  # Check if GitHub domain is valid and accessible
  if ! check_connectivity "github.com"; then
    # Error checking GitHub connectivity
    abort_script "No connection to GitHub!"
  fi

  print_step "Installing git"
  is_installed "git" || sudo apt install -y --no-install-recommends git

  if [[ -d "${HOME}/.dotfiles" ]]; then
    print_step "Updating dotfiles repo"
    git -C "${HOME}/.dotfiles" pull
  else
    print_step "Cloning dotfiles repo"
    if ! git clone https://github.com/AndrewDaws/dotfiles.git "${HOME}/.dotfiles"; then
      abort_script "Command git clone https://github.com/AndrewDaws/dotfiles.git ${HOME}/.dotfiles Failed!"
    fi
  fi

  # Set file permissions
  if [[ -f "${HOME}/.dotfiles/scripts/set_permissions.sh" ]]; then
    if ! "${HOME}/.dotfiles/scripts/set_permissions.sh"; then
      abort_script "Script ${HOME}/.dotfiles/scripts/set_permissions.sh Failed!"
    fi
  else
    abort_script "File ${HOME}/.dotfiles/scripts/set_permissions.sh Does Not Exist!"
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
  print_stage "Headless applications setup"

  # Check internet connectivity
  if ! check_connectivity; then
    # Error checking internet connectivity
    abort_script "No internet connection!"
  fi

  # Check if GitHub domain is valid and accessible
  if ! check_connectivity "github.com"; then
    # Error checking GitHub connectivity
    abort_script "No connection to GitHub!"
  fi

  #print_step "Adding repositories"

  print_step "Installing headless applications"
  sudo apt install -y --no-install-recommends \
    vim zsh htop man curl sed nano gawk nmap tmux xclip \
    ack openssh-server cron httpie iputils-ping file tree \
    python3-dev python3-pip python3-setuptools thefuck

  # Install Pip Applications
  pip3 install setuptools --upgrade
  pip3 install thefuck --upgrade

  # Install Fd
  is_installed "fd" || "${HOME}/.dotfiles/scripts/install_fd.sh"

  # Install Tmux Plugin Manager
  if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    print_step "Updating Tmux Plugin Manager repo"
    git -C "${HOME}/.tmux/plugins/tpm" pull
  else
    print_step "Cloning Tmux Plugin Manager repo"
    mkdir -p "${HOME}/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  fi

  # Install Fzf
  if [[ -d "${HOME}/.fzf" ]]; then
    print_step "Updating fzf repo"
    git -C "${HOME}/.fzf" pull
  else
    print_step "Cloning fzf repo"
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
  fi
  "${HOME}/.fzf/install" --bin

  print_step "Installing headless shell"
  # Install Oh-My-Zsh Framework
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    print_step "Updating Oh-My-Zsh repo"
    git -C "${HOME}/.oh-my-zsh" pull
  else
    print_step "Installing Oh-My-Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
  fi

  # Install Oh-My-Zsh Theme
  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    print_step "Updating Powerlevel10k repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" pull
  else
    print_step "Cloning Powerlevel10k repo"
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
  fi

  # Install Oh-My-Zsh Plugins
  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate" ]]; then
    print_step "Updating autoupdate repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate" pull
  else
    print_step "Cloning autoupdate repo"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
    print_step "Updating fast-syntax-highlighting repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" pull
  else
    print_step "Cloning fast-syntax-highlighting repo"
    git clone https://github.com/zdharma/fast-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit" ]]; then
    print_step "Updating forgit repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit" pull
  else
    print_step "Cloning forgit repo"
    git clone https://github.com/wfxr/forgit.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-tab" ]]; then
    print_step "Updating fzf-tab repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-tab" pull
  else
    print_step "Cloning fzf-tab repo"
    git clone https://github.com/Aloxaf/fzf-tab.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-tab"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z" ]]; then
    print_step "Updating fzf-z repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z" pull
  else
    print_step "Cloning fzf-z repo"
    git clone https://github.com/andrewferrier/fzf-z.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/per-directory-history" ]]; then
    print_step "Updating per-directory-history repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/per-directory-history" pull
  else
    print_step "Cloning per-directory-history repo"
    git clone https://github.com/jimhester/per-directory-history.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/per-directory-history"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autopair" ]]; then
    print_step "Updating zsh-autopair repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autopair" pull
  else
    print_step "Cloning zsh-autopair repo"
    git clone https://github.com/hlissner/zsh-autopair.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autopair"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-z" ]]; then
    print_step "Updating zsh-z repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-z" pull
  else
    print_step "Cloning zsh-z repo"
    git clone https://github.com/agkozak/zsh-z.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-z"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    print_step "Updating zsh-autosuggestions repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" pull
  else
    print_step "Cloning zsh-autosuggestions repo"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions" ]]; then
    print_step "Updating zsh-completions repo"
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions" pull
  else
    print_step "Cloning zsh-completions repo"
    git clone https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
  fi

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]]; then
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
  if [[ -f "${HOME}/.dotfiles/scripts/create_links.sh" ]]; then
    if ! "${HOME}/.dotfiles/scripts/create_links.sh" --headless; then
      abort_script "Script ${HOME}/.dotfiles/scripts/create_links.sh Failed!"
    fi
  else
    abort_script "File ${HOME}/.dotfiles/scripts/create_links.sh Does Not Exist!"
  fi
}

desktop_setup() {
  print_stage "Desktop applications setup"

  # Check internet connectivity
  if ! check_connectivity; then
    # Error checking internet connectivity
    abort_script "No internet connection!"
  fi

  # Check if GitHub domain is valid and accessible
  if ! check_connectivity "github.com"; then
    # Error checking GitHub connectivity
    abort_script "No connection to GitHub!"
  fi

  print_step "Installing desktop applications"
  sudo apt install -y --no-install-recommends \
    firefox libegl1-mesa-dev snapd make cmake \
    gcc build-essential meld pkg-config \
    libssl-dev

  # Install Alacritty
  is_installed "alacritty" || "${HOME}/.dotfiles/scripts/install_alacritty.sh"

  # Install Bat
  is_installed "bat" || "${HOME}/.dotfiles/scripts/install_bat.sh"

  # Install Delta
  is_installed "delta" || "${HOME}/.dotfiles/scripts/install_delta.sh"

  # Install Rustup
  if ! is_installed "rustup"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "${HOME}/.cargo/env"
  else
    rustup update
  fi

  # @todo Improve Cargo Package Updating
  # @body Find a way to only update cargo packages if outdated, rather than full reinstall.
  # Install Cargo Applications
  # Install Exa
  if ! is_installed "exa"; then
    cargo install exa
  else
    print_step "Skipped: exa"
  fi

  # Install tldr
  if ! is_installed "tldr"; then
    cargo install tealdeer
  else
    print_step "Skipped: tldr"
  fi

  # Update tldr Cache
  tldr --update

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
  if [[ -f "${HOME}/.dotfiles/scripts/create_links.sh" ]]; then
    if ! "${HOME}/.dotfiles/scripts/create_links.sh" --desktop; then
      abort_script "Script ${HOME}/.dotfiles/scripts/create_links.sh Failed!"
    fi
  else
    abort_script "File ${HOME}/.dotfiles/scripts/create_links.sh Does Not Exist!"
  fi
  
  # Install term environment
  if [[ -f "${HOME}/.terminfo/x/xterm-256color-italic" ]]; then
    print_step "Skipped: ${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
  else
    tic "${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
    print_step "Installed ${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
  fi

  # Create Global Git Config
  # Temporary measure until gitconfig logic is fixed.
  if [[ -f "${HOME}/.gitconfig" ]]; then
    print_step "Skipped: ${HOME}/.dotfiles/scripts/create_gitconfig.sh"
  else
    "${HOME}/.dotfiles/scripts/create_gitconfig.sh"
  fi
}

final_setup() {
  print_stage "Final setup"

  update_packages

  # @todo Fix Self-Deletion
  # @body Fix the logic to delete the install script if not executed from dotfiles path.
  #if [[ "$(dirname "${0}")" != "${HOME}/.dotfiles/scripts" ]]; then
  #  print_step "Deleting temporary install script"
  #  rm -f "$(dirname "${0}")/$(basename "${0}")"
  #fi

  print_step "Changing shell"
  sudo usermod -s "$(which zsh)" "${USER}"
  env zsh -l
}

main() {
  # Declare local variables
  local argument_flag
  local headless_mode
  local desktop_mode

  # Initialize local variables
  argument_flag="false"
  headless_mode="disabled"
  desktop_mode="disabled"

  if [[ -n "${*}" ]]; then
    # Process arguments
    for argument in "${@}"; do
      argument_flag="true"
      if [[ "${argument}" == "-?" || "${argument}" == "--help" ]]; then
        abort_script "Usage:" "  $(basename "${0}") [options]" "  -?, --help      show list of command-line options" "" "OPTIONS" "  -h, --headless  force enable headless mode" "  -d, --desktop   force enable desktop mode"
      elif [[ "${argument}" == "-h" || "${argument}" == "--headless" ]]; then
        headless_mode="enabled"
      elif [[ "${argument}" == "-d" || "${argument}" == "--desktop" ]]; then
        desktop_mode="enabled"
      else
        abort_script "Invalid Argument!" "" "Usage:" "  $(basename "${0}") [options]" "  -?, --help      show list of command-line options"
      fi
    done
  fi

  # @todo Single Sudo Prompt
  # @body Automate sudo password prompt so it is only asked for once.

  repo_setup

  # Determine system type if no arguments given
  if [[ "${argument_flag}" == "false" ]]; then
    if [[ -f "${HOME}/.dotfiles/scripts/is_desktop.sh" ]]; then
      "${HOME}/.dotfiles/scripts/is_desktop.sh" > /dev/null \
        && desktop_mode="enabled" \
        || headless_mode="enabled"
    else
      abort_script "File ${HOME}/.dotfiles/scripts/is_desktop.sh Does Not Exist!"
    fi
  fi

  initial_setup

  if [[ "${argument_flag}" == "false" || "${headless_mode}" == "enabled" ]]; then
    headless_setup
  fi

  if [[ "${desktop_mode}" == "enabled" ]]; then
    desktop_setup
  fi

  final_setup
}

main "${*}"

exit 0
