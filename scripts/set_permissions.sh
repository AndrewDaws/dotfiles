#!/bin/bash
# Creates sym-links to dotfiles stored in the repo.
script_name="$(basename "${0}")"

argument_flag="false"
alacritty_mode="disabled"
alias_mode="disabled"
fonts_mode="disabled"
git_mode="disabled"
gnome_mode="disabled"
hardware_mode="disabled"
htop_mode="disabled"
projects_mode="disabled"
scripts_mode="disabled"
term_mode="disabled"
tmux_mode="disabled"
vim_mode="disabled"
zsh_mode="disabled"

# Process arguments
for argument in "${@}"; do
  argument_flag="true"
  if [[ "${argument}" == "-?" || "${argument}" == "--help" ]]; then
    echo "Usage:"
    echo "  ${script_name} [options]"
    echo "  -?, --help    show list of command-line options"
    echo ""
    echo "OPTIONS"
    echo "      --alacritty    force enable alacritty mode"
    echo "  -a, --alias        force enable alias mode"
    echo "      --fonts        force enable fonts mode"
    echo "  -g, --git          force enable git mode"
    echo "      --gnome        force enable gnome mode"
    echo "      --hardware     force enable hardware mode"
    echo "      --htop         force enable htop mode"
    echo "  -p, --projects     force enable projects mode"
    echo "  -s, --scripts      force enable scripts mode"
    echo "      --term         force enable term mode"
    echo "  -t, --tmux         force enable tmux mode"
    echo "  -v, --vim          force enable vim mode"
    echo "  -z, --zsh          force enable zsh mode"
    exit 0
  elif [[ "${argument}" == "--alacritty" ]]; then
    alacritty_mode="enabled"
  elif [[ "${argument}" == "-a" || "${argument}" == "--alias" ]]; then
    alias_mode="enabled"
  elif [[ "${argument}" == "--fonts" ]]; then
    fonts_mode="enabled"
  elif [[ "${argument}" == "-g" || "${argument}" == "--git" ]]; then
    git_mode="enabled"
  elif [[ "${argument}" == "--gnome" ]]; then
    gnome_mode="enabled"
  elif [[ "${argument}" == "--hardware" ]]; then
    hardware_mode="enabled"
  elif [[ "${argument}" == "--htop" ]]; then
    htop_mode="enabled"
  elif [[ "${argument}" == "-p" || "${argument}" == "--projects" ]]; then
    projects_mode="enabled"
  elif [[ "${argument}" == "-s" || "${argument}" == "--scripts" ]]; then
    scripts_mode="enabled"
  elif [[ "${argument}" == "--term" ]]; then
    term_mode="enabled"
  elif [[ "${argument}" == "-t" || "${argument}" == "--tmux" ]]; then
    tmux_mode="enabled"
  elif [[ "${argument}" == "-v" || "${argument}" == "--vim" ]]; then
    vim_mode="enabled"
  elif [[ "${argument}" == "-z" || "${argument}" == "--zsh" ]]; then
    zsh_mode="enabled"
  else
    echo "Aborting ${script_name}"
    echo "  Invalid Argument!"
    echo ""
    echo "Usage:"
    echo "  ${script_name} [options]"
    echo "  -?, --help    show list of command-line options"
    exit 1
  fi
done

# Begin setting file permissions
echo '=> Setting Permissions'

# Alacritty
if [[ "${argument_flag}" == "false" || "${alacritty_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/alacritty" ]]; then
    find "${HOME}/.dotfiles/alacritty" -type f -exec chmod 640 {} \;
    find "${HOME}/.dotfiles/alacritty" -type f -exec echo "Modified: {} = 640" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/alacritty Does Not Exist!"
    exit 1
  fi
fi

# Fonts
if [[ "${argument_flag}" == "false" || "${fonts_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/fonts" ]]; then
    find "${HOME}/.dotfiles/fonts" -type f -exec chmod 644 {} \;
    find "${HOME}/.dotfiles/fonts" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/fonts Does Not Exist!"
    exit 1
  fi
fi

# Git
if [[ "${argument_flag}" == "false" || "${git_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/git" ]]; then
    find "${HOME}/.dotfiles/git" -type f -exec chmod 664 {} \;
    find "${HOME}/.dotfiles/git" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/git Does Not Exist!"
    exit 1
  fi
fi

# Gnome
if [[ "${argument_flag}" == "false" || "${gnome_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/gnome" ]]; then
    find "${HOME}/.dotfiles/gnome" -type f -exec chmod 664 {} \;
    find "${HOME}/.dotfiles/gnome" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/gnome Does Not Exist!"
    exit 1
  fi
fi

# Hardware
if [[ "${argument_flag}" == "false" || "${hardware_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/hardware" ]]; then
    find "${HOME}/.dotfiles/hardware" -type f -exec chmod 644 {} \;
    find "${HOME}/.dotfiles/hardware" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/hardware Does Not Exist!"
    exit 1
  fi
fi

# Htop
if [[ "${argument_flag}" == "false" || "${htop_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/htop" ]]; then
    find "${HOME}/.dotfiles/htop" -type f -exec chmod 664 {} \;
    find "${HOME}/.dotfiles/htop" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/htop Does Not Exist!"
    exit 1
  fi
fi

# Projects
if [[ "${argument_flag}" == "false" || "${projects_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/projects" ]]; then
    find "${HOME}/.dotfiles/projects" -type f -exec chmod 644 {} \;
    find "${HOME}/.dotfiles/projects" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/projects Does Not Exist!"
    exit 1
  fi
fi

# Scripts
if [[ "${argument_flag}" == "false" || "${scripts_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/scripts" ]]; then
    find "${HOME}/.dotfiles/scripts" -type f -exec chmod 755 {} \;
    find "${HOME}/.dotfiles/scripts" -type f -exec echo "Modified: {} = 755" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/scripts Does Not Exist!"
    exit 1
  fi
fi

# Term
if [[ "${argument_flag}" == "false" || "${term_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/term" ]]; then
    find "${HOME}/.dotfiles/term" -type f -exec chmod 664 {} \;
    find "${HOME}/.dotfiles/term" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/term Does Not Exist!"
    exit 1
  fi
fi

# Tmux
if [[ "${argument_flag}" == "false" || "${tmux_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/tmux" ]]; then
    find "${HOME}/.dotfiles/tmux" -type f -exec chmod 644 {} \;
    find "${HOME}/.dotfiles/tmux" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/tmux Does Not Exist!"
    exit 1
  fi
fi

# Vim
if [[ "${argument_flag}" == "false" || "${vim_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/vim" ]]; then
    find "${HOME}/.dotfiles/vim" -type f -exec chmod 644 {} \;
    find "${HOME}/.dotfiles/vim" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/vim Does Not Exist!"
    exit 1
  fi
fi

# Zsh
if [[ "${argument_flag}" == "false" || "${zsh_mode}" == "enabled" ]]; then
  if [[ -d "${HOME}/.dotfiles/zsh" ]]; then
    find "${HOME}/.dotfiles/zsh" -type f -exec chmod 644 {} \;
    find "${HOME}/.dotfiles/zsh" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${HOME}/.dotfiles/zsh Does Not Exist!"
    exit 1
  fi
fi

exit 0
