#!/bin/bash
# Creates sym-links to dotfiles stored in the repo.
script_name="$(basename "${0}")"

argument_flag="false"
alacritty_mode="disabled"
alias_mode="disabled"
fonts_mode="disabled"
git_mode="disabled"
gnome_mode="disabled"
projects_mode="disabled"
scripts_mode="disabled"
term_mode="disabled"
tmux_mode="disabled"
vim_mode="disabled"
zsh_mode="disabled"

# Process arguments
for argument in "${@}"
do
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
    echo "  -g, --git          force git alias mode"
    echo "      --gnome        force gnome alias mode"
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



# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
  if [[ -f "${HOME}/.dotfiles/zsh/.paths.zsh" ]]; then
    source "${HOME}/.dotfiles/zsh/.paths.zsh"
  else
    echo "Aborting ${script_name}"
    echo "  File ${HOME}/.dotfiles/zsh/.paths.zsh Does Not Exist!"
    exit 1
  fi
fi



# Begin setting file permissions
echo '=> Setting Permissions'

# Alacritty
if [[ "${argument_flag}" == "false" || "${alacritty_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_ALACRITTY_PATH}" ]]; then
    find "${DOTFILES_ALACRITTY_PATH}" -type f -exec chmod 640 {} \;
    find "${DOTFILES_ALACRITTY_PATH}" -type f -exec echo "Modified: {} = 640" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_ALACRITTY_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Alias
if [[ "${argument_flag}" == "false" || "${alias_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_ALIAS_PATH}" ]]; then
    find "${DOTFILES_ALIAS_PATH}" -type f -exec chmod 644 {} \;
    find "${DOTFILES_ALIAS_PATH}" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_ALIAS_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Fonts
if [[ "${argument_flag}" == "false" || "${fonts_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_FONTS_PATH}" ]]; then
    find "${DOTFILES_FONTS_PATH}" -type f -exec chmod 644 {} \;
    find "${DOTFILES_FONTS_PATH}" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_FONTS_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Git
if [[ "${argument_flag}" == "false" || "${git_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_GIT_PATH}" ]]; then
    find "${DOTFILES_GIT_PATH}" -type f -exec chmod 664 {} \;
    find "${DOTFILES_GIT_PATH}" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_GIT_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Gnome
if [[ "${argument_flag}" == "false" || "${gnome_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_GNOME_PATH}" ]]; then
    find "${DOTFILES_GNOME_PATH}" -type f -exec chmod 664 {} \;
    find "${DOTFILES_GNOME_PATH}" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_GNOME_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Projects
if [[ "${argument_flag}" == "false" || "${projects_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_PROJECTS_PATH}" ]]; then
    find "${DOTFILES_PROJECTS_PATH}" -type f -exec chmod 644 {} \;
    find "${DOTFILES_PROJECTS_PATH}" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_PROJECTS_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Scripts
if [[ "${argument_flag}" == "false" || "${scripts_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_SCRIPTS_PATH}" ]]; then
    find "${DOTFILES_SCRIPTS_PATH}" -type f -exec chmod 755 {} \;
    find "${DOTFILES_SCRIPTS_PATH}" -type f -exec echo "Modified: {} = 755" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_SCRIPTS_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Term
if [[ "${argument_flag}" == "false" || "${term_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_TERM_PATH}" ]]; then
    find "${DOTFILES_TERM_PATH}" -type f -exec chmod 664 {} \;
    find "${DOTFILES_TERM_PATH}" -type f -exec echo "Modified: {} = 664" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_TERM_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Tmux
if [[ "${argument_flag}" == "false" || "${tmux_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_TMUX_PATH}" ]]; then
    find "${DOTFILES_TMUX_PATH}" -type f -exec chmod 644 {} \;
    find "${DOTFILES_TMUX_PATH}" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_TMUX_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Vim
if [[ "${argument_flag}" == "false" || "${vim_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_VIM_PATH}" ]]; then
    find "${DOTFILES_VIM_PATH}" -type f -exec chmod 644 {} \;
    find "${DOTFILES_VIM_PATH}" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_VIM_PATH} Does Not Exist!"
    exit 1
  fi
fi

# Zsh
if [[ "${argument_flag}" == "false" || "${zsh_mode}" == "enabled" ]]; then
  if [[ -d "${DOTFILES_ZSH_PATH}" ]]; then
    find "${DOTFILES_ZSH_PATH}" -type f -exec chmod 644 {} \;
    find "${DOTFILES_ZSH_PATH}" -type f -exec echo "Modified: {} = 644" \;
  else
    echo "Aborting ${script_name}"
    echo "  Directory ${DOTFILES_ZSH_PATH} Does Not Exist!"
    exit 1
  fi
fi

exit 0
