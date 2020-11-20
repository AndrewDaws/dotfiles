#!/bin/bash
# Creates sym-links to dotfiles stored in the repo.
script_name="$(basename "${0}")"

argument_flag="false"
headless_mode="disabled"
desktop_mode="disabled"

# Process arguments
for argument in "${@}"
do
  argument_flag="true"
  if [[ "${argument}" == "-?" || "${argument}" == "--help" ]]; then
    echo "Usage:"
    echo "  ${script_name} [options]"
    echo "  -?, --help      show list of command-line options"
    echo ""
    echo "OPTIONS"
    echo "  -h, --headless  force enable headless mode"
    echo "  -d, --desktop   force enable desktop mode"
    exit 0
  elif [[ "${argument}" == "-h" || "${argument}" == "--headless" ]]; then
    headless_mode="enabled"
  elif [[ "${argument}" == "-d" || "${argument}" == "--desktop" ]]; then
    desktop_mode="enabled"
  else
    echo "Aborting ${script_name}"
    echo "  Invalid Argument!"
    echo ""
    echo "Usage:"
    echo "  ${script_name} [options]"
    echo "  -?, --help      show list of command-line options"
    exit 1
  fi
done



# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
  if [[ -f "${HOME}/.dotfiles/zsh/.paths.zsh" ]]; then
    source "${HOME}/.dotfiles/zsh/.paths.zsh"
  else
    echo "Aborting ${HOME}/.dotfiles/zsh/.paths.zsh"
    echo "  File ${HOME}/.dotfiles/zsh/.paths.zsh Does Not Exist!"
    exit 1
  fi
fi



# Determine system type if no arguments given
if [[ "${argument_flag}" == "false" ]]; then
  if [[ -f "${DOTFILES_SCRIPTS_PATH}/is_desktop.sh" ]]; then
    "${DOTFILES_SCRIPTS_PATH}/is_desktop.sh" > /dev/null \
      && desktop_mode="enabled" \
      || headless_mode="enabled"
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_SCRIPTS_PATH}/is_desktop.sh Does Not Exist!"
    exit 1
  fi
fi



# Begin creating links
# Headless applications links
if [[ "${argument_flag}" == "false" || "${headless_mode}" == "enabled" ]]; then
  echo '=> Linking Headless Applications'

  if [[ -f "${DOTFILES_ZSH_PATH}/.zshrc" ]]; then
    if [[ "$(readlink -f "${HOME}/.zshrc")" == "${DOTFILES_ZSH_PATH}/.zshrc" ]]; then
      echo "Skipped: ${HOME}/.zshrc"
    else
      if [[ -f "${HOME}/.zshrc" ]]; then
        rm -f "${HOME}/.zshrc"
      fi
      ln -s "${DOTFILES_ZSH_PATH}/.zshrc" "${HOME}/.zshrc"
      echo "Linked: ${HOME}/.zshrc -> ${DOTFILES_ZSH_PATH}/.zshrc"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_ZSH_PATH}/.zshrc Does Not Exist!"
    exit 1
  fi

  if [[ -f "${DOTFILES_ZSH_PATH}/.p10k.zsh" ]]; then
    if [[ "$(readlink -f "${HOME}/.p10k.zsh")" == "${DOTFILES_ZSH_PATH}/.p10k.zsh" ]]; then
      echo "Skipped: ${HOME}/.p10k.zsh"
    else
      if [[ -f "${HOME}/.p10k.zsh" ]]; then
        rm -f "${HOME}/.p10k.zsh"
      fi
      ln -s "${DOTFILES_ZSH_PATH}/.p10k.zsh" "${HOME}/.p10k.zsh"
      echo "Linked: ${HOME}/.p10k.zsh -> ${DOTFILES_ZSH_PATH}/.p10k.zsh"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_ZSH_PATH}/.p10k.zsh Does Not Exist!"
    exit 1
  fi

  if [[ -f "${DOTFILES_TMUX_PATH}/.tmux.conf" ]]; then
    if [[ "$(readlink -f "${HOME}/.tmux.conf")" == "${DOTFILES_TMUX_PATH}/.tmux.conf" ]]; then
      echo "Skipped: ${HOME}/.tmux.conf"
    else
      if [[ -f "${HOME}/.tmux.conf" ]]; then
        rm -f "${HOME}/.tmux.conf"
      fi
      ln -s "${DOTFILES_TMUX_PATH}/.tmux.conf" "${HOME}/.tmux.conf"
      echo "Linked: ${HOME}/.tmux.conf -> ${DOTFILES_TMUX_PATH}/.tmux.conf"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_TMUX_PATH}/.tmux.conf Does Not Exist!"
    exit 1
  fi

  if [[ -f "${DOTFILES_VIM_PATH}/.vimrc" ]]; then
    if [[ "$(readlink -f "${HOME}/.vimrc")" == "${DOTFILES_VIM_PATH}/.vimrc" ]]; then
      echo "Skipped: ${HOME}/.vimrc"
    else
      if [[ -f "${HOME}/.vimrc" ]]; then
        rm -f "${HOME}/.vimrc"
      fi
      ln -s "${DOTFILES_VIM_PATH}/.vimrc" "${HOME}/.vimrc"
      echo "Linked: ${HOME}/.vimrc -> ${DOTFILES_VIM_PATH}/.vimrc"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_VIM_PATH}/.vimrc Does Not Exist!"
    exit 1
  fi
fi

# Desktop applications links
if [[ "${desktop_mode}" == "enabled" ]]; then
  echo "=> Linking Desktop Applications"

  if [[ -f "${DOTFILES_GNOME_PATH}/gtk.css" ]]; then
    if [[ "$(readlink -f "${HOME}/.config/gtk-3.0/gtk.css")" == "${DOTFILES_GNOME_PATH}/gtk.css" ]]; then
      echo "Skipped: ${HOME}/.config/gtk-3.0/gtk.css"
    else
      if [[ -f "${HOME}/.config/gtk-3.0/gtk.css" ]]; then
        rm -f "${HOME}/.config/gtk-3.0/gtk.css"
      elif [[ ! -d "${HOME}/.config/gtk-3.0" ]]; then
        mkdir -p "${HOME}/.config/gtk-3.0"
        chmod 775 "${HOME}/.config/gtk-3.0"
      fi
      ln -s "${DOTFILES_GNOME_PATH}/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
      echo "Linked: ${HOME}/.config/gtk-3.0/gtk.css -> ${DOTFILES_GNOME_PATH}/gtk.css"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_GNOME_PATH}/gtk.css Does Not Exist!"
    exit 1
  fi

  if [[ -f "${DOTFILES_GNOME_PATH}/settings.ini" ]]; then
    if [[ "$(readlink -f "${HOME}/.config/gtk-3.0/settings.ini")" == "${DOTFILES_GNOME_PATH}/settings.ini" ]]; then
      echo "Skipped: ${HOME}/.config/gtk-3.0/settings.ini"
    else
      if [[ -f "${HOME}/.config/gtk-3.0/settings.ini" ]]; then
        rm -f "${HOME}/.config/gtk-3.0/settings.ini"
      elif [[ ! -d "${HOME}/.config/gtk-3.0" ]]; then
        mkdir -p "${HOME}/.config/gtk-3.0"
        chmod 775 "${HOME}/.config/gtk-3.0"
      fi
      ln -s "${DOTFILES_GNOME_PATH}/settings.ini" "${HOME}/.config/gtk-3.0/settings.ini"
      echo "Linked: ${HOME}/.config/gtk-3.0/settings.ini -> ${DOTFILES_GNOME_PATH}/settings.ini"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_GNOME_PATH}/settings.ini Does Not Exist!"
    exit 1
  fi

  if [[ -f "${DOTFILES_GNOME_PATH}/settings.ini" ]]; then
    if [[ "$(readlink -f "${HOME}/.config/gtk-4.0/settings.ini")" == "${DOTFILES_GNOME_PATH}/settings.ini" ]]; then
      echo "Skipped: ${HOME}/.config/gtk-4.0/settings.ini"
    else
      if [[ -f "${HOME}/.config/gtk-4.0/settings.ini" ]]; then
        rm -f "${HOME}/.config/gtk-4.0/settings.ini"
      elif [[ ! -d "${HOME}/.config/gtk-4.0" ]]; then
        mkdir -p "${HOME}/.config/gtk-4.0"
        chmod 775 "${HOME}/.config/gtk-4.0"
      fi
      ln -s "${DOTFILES_GNOME_PATH}/settings.ini" "${HOME}/.config/gtk-4.0/settings.ini"
      echo "Linked: ${HOME}/.config/gtk-4.0/settings.ini -> ${DOTFILES_GNOME_PATH}/settings.ini"
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_GNOME_PATH}/settings.ini Does Not Exist!"
    exit 1
  fi

  if [[ -d "${HOME}/.local/share/fonts/OperatorMono" ]]; then
    if [[ -f "${DOTFILES_ALACRITTY_PATH}/alacritty-operatormono.yml" ]]; then
      if [[ "$(readlink -f "${HOME}/.config/alacritty/alacritty.yml")" == "${DOTFILES_ALACRITTY_PATH}/alacritty-operatormono.yml" ]]; then
        echo "Skipped: ${HOME}/.config/alacritty/alacritty.yml"
      else
        if [[ -f "${HOME}/.config/alacritty/alacritty.yml" ]]; then
          rm -f "${HOME}/.config/alacritty/alacritty.yml"
        elif [[ ! -d "${HOME}/.config/alacritty" ]]; then
          mkdir -p "${HOME}/.config/alacritty"
          chmod 700 "${HOME}/.config/alacritty"
        fi
        ln -s "${DOTFILES_ALACRITTY_PATH}/alacritty-operatormono.yml" "${HOME}/.config/alacritty/alacritty.yml"
        echo "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${DOTFILES_ALACRITTY_PATH}/alacritty-operatormono.yml"
      fi
    else
      echo "Aborting ${script_name}"
      echo "  File ${DOTFILES_ALACRITTY_PATH}/alacritty-operatormono.yml Does Not Exist!"
      exit 1
    fi
  elif [[ -d "${HOME}/.local/share/fonts/JetBrains" ]]; then
    if [[ -f "${DOTFILES_ALACRITTY_PATH}/alacritty-jetbrainsmono.yml" ]]; then
      if [[ "$(readlink -f "${HOME}/.config/alacritty/alacritty.yml")" == "${DOTFILES_ALACRITTY_PATH}/alacritty-jetbrainsmono.yml" ]]; then
        echo "Skipped: ${HOME}/.config/alacritty/alacritty.yml"
      else
        if [[ -f "${HOME}/.config/alacritty/alacritty.yml" ]]; then
          rm -f "${HOME}/.config/alacritty/alacritty.yml"
        elif [[ ! -d "${HOME}/.config/alacritty" ]]; then
          mkdir -p "${HOME}/.config/alacritty"
          chmod 700 "${HOME}/.config/alacritty"
        fi
        ln -s "${DOTFILES_ALACRITTY_PATH}/alacritty-jetbrainsmono.yml" "${HOME}/.config/alacritty/alacritty.yml"
        echo "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${DOTFILES_ALACRITTY_PATH}/alacritty-jetbrainsmono.yml"
      fi
    else
      echo "Aborting ${script_name}"
      echo "  File ${DOTFILES_ALACRITTY_PATH}/alacritty-jetbrainsmono.yml Does Not Exist!"
      exit 1
    fi
  else
    if [[ -f "${DOTFILES_ALACRITTY_PATH}/alacritty-firacode.yml" ]]; then
      if [[ "$(readlink -f "${HOME}/.config/alacritty/alacritty.yml")" == "${DOTFILES_ALACRITTY_PATH}/alacritty-firacode.yml" ]]; then
        echo "Skipped: ${HOME}/.config/alacritty/alacritty.yml"
      else
        if [[ -f "${HOME}/.config/alacritty/alacritty.yml" ]]; then
          rm -f "${HOME}/.config/alacritty/alacritty.yml"
        elif [[ ! -d "${HOME}/.config/alacritty" ]]; then
          mkdir -p "${HOME}/.config/alacritty"
          chmod 700 "${HOME}/.config/alacritty"
        fi
        ln -s "${DOTFILES_ALACRITTY_PATH}/alacritty-firacode.yml" "${HOME}/.config/alacritty/alacritty.yml"
        echo "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${DOTFILES_ALACRITTY_PATH}/alacritty-firacode.yml"
      fi
    else
      echo "Aborting ${script_name}"
      echo "  File ${DOTFILES_ALACRITTY_PATH}/alacritty-firacode.yml Does Not Exist!"
      exit 1
    fi
  fi
fi

exit 0
