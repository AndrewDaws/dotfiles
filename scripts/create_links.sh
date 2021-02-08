#!/bin/bash
# Creates sym-links to dotfiles stored in the repo.

if [[ -f "${HOME}/.dotfiles/functions/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "${HOME}/.dotfiles/functions/.functions"
else
  echo "Could not find .functions file in dotfiles directory!"
  exit "1"
fi

link_headless() {
  abort_file_exists "${HOME}/.dotfiles/zsh/.zshrc"
  if [[ "$(readlink -f "${HOME}/.zshrc")" == "${HOME}/.dotfiles/zsh/.zshrc" ]]; then
    print_step "Skipped: ${HOME}/.zshrc"
  else
    if file_exists "${HOME}/.zshrc"; then
      rm -f "${HOME}/.zshrc"
    fi
    ln -s "${HOME}/.dotfiles/zsh/.zshrc" "${HOME}/.zshrc"
    print_step "Linked: ${HOME}/.zshrc -> ${HOME}/.dotfiles/zsh/.zshrc"
  fi

  abort_file_exists "${HOME}/.dotfiles/zsh/.p10k.zsh"
  if [[ "$(readlink -f "${HOME}/.p10k.zsh")" == "${HOME}/.dotfiles/zsh/.p10k.zsh" ]]; then
    print_step "Skipped: ${HOME}/.p10k.zsh"
  else
    if file_exists "${HOME}/.p10k.zsh"; then
      rm -f "${HOME}/.p10k.zsh"
    fi
    ln -s "${HOME}/.dotfiles/zsh/.p10k.zsh" "${HOME}/.p10k.zsh"
    print_step "Linked: ${HOME}/.p10k.zsh -> ${HOME}/.dotfiles/zsh/.p10k.zsh"
  fi

  abort_file_exists "${HOME}/.dotfiles/tmux/.tmux.conf"
  if [[ "$(readlink -f "${HOME}/.tmux.conf")" == "${HOME}/.dotfiles/tmux/.tmux.conf" ]]; then
    print_step "Skipped: ${HOME}/.tmux.conf"
  else
    if file_exists "${HOME}/.tmux.conf"; then
      rm -f "${HOME}/.tmux.conf"
    fi
    ln -s "${HOME}/.dotfiles/tmux/.tmux.conf" "${HOME}/.tmux.conf"
    print_step "Linked: ${HOME}/.tmux.conf -> ${HOME}/.dotfiles/tmux/.tmux.conf"
  fi

  abort_file_exists "${HOME}/.dotfiles/vim/.vimrc"
  if [[ "$(readlink -f "${HOME}/.vimrc")" == "${HOME}/.dotfiles/vim/.vimrc" ]]; then
    print_step "Skipped: ${HOME}/.vimrc"
  else
    if file_exists "${HOME}/.vimrc"; then
      rm -f "${HOME}/.vimrc"
    fi
    ln -s "${HOME}/.dotfiles/vim/.vimrc" "${HOME}/.vimrc"
    print_step "Linked: ${HOME}/.vimrc -> ${HOME}/.dotfiles/vim/.vimrc"
  fi
}

link_desktop() {
  abort_file_exists "${HOME}/.dotfiles/gnome/gtk.css"
  if [[ "$(readlink -f "${HOME}/.config/gtk-3.0/gtk.css")" == "${HOME}/.dotfiles/gnome/gtk.css" ]]; then
    print_step "Skipped: ${HOME}/.config/gtk-3.0/gtk.css"
  else
    if file_exists "${HOME}/.config/gtk-3.0/gtk.css"; then
      rm -f "${HOME}/.config/gtk-3.0/gtk.css"
    elif ! directory_exists "${HOME}/.config/gtk-3.0"; then
      mkdir -p "${HOME}/.config/gtk-3.0"
      chmod 775 "${HOME}/.config/gtk-3.0"
    fi
    ln -s "${HOME}/.dotfiles/gnome/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
    print_step "Linked: ${HOME}/.config/gtk-3.0/gtk.css -> ${HOME}/.dotfiles/gnome/gtk.css"
  fi

  abort_file_exists "${HOME}/.dotfiles/gnome/settings.ini"
  if [[ "$(readlink -f "${HOME}/.config/gtk-3.0/settings.ini")" == "${HOME}/.dotfiles/gnome/settings.ini" ]]; then
    print_step "Skipped: ${HOME}/.config/gtk-3.0/settings.ini"
  else
    if file_exists "${HOME}/.config/gtk-3.0/settings.ini"; then
      rm -f "${HOME}/.config/gtk-3.0/settings.ini"
    elif ! directory_exists "${HOME}/.config/gtk-3.0"; then
      mkdir -p "${HOME}/.config/gtk-3.0"
      chmod 775 "${HOME}/.config/gtk-3.0"
    fi
    ln -s "${HOME}/.dotfiles/gnome/settings.ini" "${HOME}/.config/gtk-3.0/settings.ini"
    print_step "Linked: ${HOME}/.config/gtk-3.0/settings.ini -> ${HOME}/.dotfiles/gnome/settings.ini"
  fi

  abort_file_exists "${HOME}/.dotfiles/gnome/settings.ini"
  if [[ "$(readlink -f "${HOME}/.config/gtk-4.0/settings.ini")" == "${HOME}/.dotfiles/gnome/settings.ini" ]]; then
    print_step "Skipped: ${HOME}/.config/gtk-4.0/settings.ini"
  else
    if file_exists "${HOME}/.config/gtk-4.0/settings.ini"; then
      rm -f "${HOME}/.config/gtk-4.0/settings.ini"
    elif ! directory_exists "${HOME}/.config/gtk-4.0"; then
      mkdir -p "${HOME}/.config/gtk-4.0"
      chmod 775 "${HOME}/.config/gtk-4.0"
    fi
    ln -s "${HOME}/.dotfiles/gnome/settings.ini" "${HOME}/.config/gtk-4.0/settings.ini"
    print_step "Linked: ${HOME}/.config/gtk-4.0/settings.ini -> ${HOME}/.dotfiles/gnome/settings.ini"
  fi

  if [[ -d "${HOME}/.local/share/fonts/OperatorMono" ]]; then
    abort_file_exists "${HOME}/.dotfiles/alacritty/alacritty-operatormono.yml"
    if [[ "$(readlink -f "${HOME}/.config/alacritty/alacritty.yml")" == "${HOME}/.dotfiles/alacritty/alacritty-operatormono.yml" ]]; then
      print_step "Skipped: ${HOME}/.config/alacritty/alacritty.yml"
    else
      if file_exists "${HOME}/.config/alacritty/alacritty.yml"; then
        rm -f "${HOME}/.config/alacritty/alacritty.yml"
      elif ! directory_exists "${HOME}/.config/alacritty"; then
        mkdir -p "${HOME}/.config/alacritty"
        chmod 700 "${HOME}/.config/alacritty"
      fi
      ln -s "${HOME}/.dotfiles/alacritty/alacritty-operatormono.yml" "${HOME}/.config/alacritty/alacritty.yml"
      print_step "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${HOME}/.dotfiles/alacritty/alacritty-operatormono.yml"
    fi
  elif [[ -d "${HOME}/.local/share/fonts/JetBrains" ]]; then
    abort_file_exists "${HOME}/.dotfiles/alacritty/alacritty-jetbrainsmono.yml"
    if [[ "$(readlink -f "${HOME}/.config/alacritty/alacritty.yml")" == "${HOME}/.dotfiles/alacritty/alacritty-jetbrainsmono.yml" ]]; then
      print_step "Skipped: ${HOME}/.config/alacritty/alacritty.yml"
    else
      if file_exists "${HOME}/.config/alacritty/alacritty.yml"; then
        rm -f "${HOME}/.config/alacritty/alacritty.yml"
      elif ! directory_exists "${HOME}/.config/alacritty"; then
        mkdir -p "${HOME}/.config/alacritty"
        chmod 700 "${HOME}/.config/alacritty"
      fi
      ln -s "${HOME}/.dotfiles/alacritty/alacritty-jetbrainsmono.yml" "${HOME}/.config/alacritty/alacritty.yml"
      print_step "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${HOME}/.dotfiles/alacritty/alacritty-jetbrainsmono.yml"
    fi
  else
    abort_file_exists "${HOME}/.dotfiles/alacritty/alacritty-firacode.yml"
    if [[ "$(readlink -f "${HOME}/.config/alacritty/alacritty.yml")" == "${HOME}/.dotfiles/alacritty/alacritty-firacode.yml" ]]; then
      print_step "Skipped: ${HOME}/.config/alacritty/alacritty.yml"
    else
      if file_exists "${HOME}/.config/alacritty/alacritty.yml"; then
        rm -f "${HOME}/.config/alacritty/alacritty.yml"
      elif ! directory_exists "${HOME}/.config/alacritty"; then
        mkdir -p "${HOME}/.config/alacritty"
        chmod 700 "${HOME}/.config/alacritty"
      fi
      ln -s "${HOME}/.dotfiles/alacritty/alacritty-firacode.yml" "${HOME}/.config/alacritty/alacritty.yml"
      print_step "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${HOME}/.dotfiles/alacritty/alacritty-firacode.yml"
    fi
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

  if [[ "${headless_mode}" == "enabled" ]]; then
    link_headless
  fi

  if [[ "${desktop_mode}" == "enabled" ]]; then
    link_desktop
  fi
}

main "${*}"

exit_script "0"
