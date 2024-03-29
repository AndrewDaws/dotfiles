#!/bin/bash
#
# Set permissions of files and directories

if [[ -f "$(dirname "$(readlink -f "${0}")")/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "$(dirname "$(readlink -f "${0}")")/.functions"
else
  echo "File does not exist!"
  echo "  $(dirname "$(readlink -f "${0}")")/.functions"
  exit "1"
fi

# Temporary variables
argument_flag="false"
alacritty_mode="disabled"
fonts_mode="disabled"
git_mode="disabled"
gnome_mode="disabled"
hardware_mode="disabled"
htop_mode="disabled"
projects_mode="disabled"
pulse_mode="disabled"
scripts_mode="disabled"
terminfo_mode="disabled"
tmux_mode="disabled"
udev_mode="disabled"
viddy_mode="disabled"
vim_mode="disabled"
zsh_mode="disabled"

# Process arguments
for argument in "${@}"; do
  argument_flag="true"
  if [[ "${argument}" == "-?" || "${argument}" == "--help" ]]; then
    echo "Usage:"
    echo "  $(script_filename) [options]"
    echo "  -?, --help    show list of command-line options"
    echo ""
    echo "OPTIONS"
    echo "      --alacritty    force enable alacritty mode"
    echo "      --fonts        force enable fonts mode"
    echo "  -g, --git          force enable git mode"
    echo "      --gnome        force enable gnome mode"
    echo "      --hardware     force enable hardware mode"
    echo "      --htop         force enable htop mode"
    echo "  -p, --projects     force enable projects mode"
    echo "      --pulse        force enable pulse mode"
    echo "  -s, --scripts      force enable scripts mode"
    echo "      --terminfo     force enable terminfo mode"
    echo "  -t, --tmux         force enable tmux mode"
    echo "      --udev         force enable udev mode"
    echo "      --viddy        force enable viddy mode"
    echo "  -v, --vim          force enable vim mode"
    echo "  -z, --zsh          force enable zsh mode"
    exit 0
  elif [[ "${argument}" == "--alacritty" ]]; then
    alacritty_mode="enabled"
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
  elif [[ "${argument}" == "--pulse" ]]; then
    pulse_mode="enabled"
  elif [[ "${argument}" == "-s" || "${argument}" == "--scripts" ]]; then
    scripts_mode="enabled"
  elif [[ "${argument}" == "--terminfo" ]]; then
    terminfo_mode="enabled"
  elif [[ "${argument}" == "-t" || "${argument}" == "--tmux" ]]; then
    tmux_mode="enabled"
  elif [[ "${argument}" == "--udev" ]]; then
    udev_mode="enabled"
  elif [[ "${argument}" == "--viddy" ]]; then
    viddy_mode="enabled"
  elif [[ "${argument}" == "-v" || "${argument}" == "--vim" ]]; then
    vim_mode="enabled"
  elif [[ "${argument}" == "-z" || "${argument}" == "--zsh" ]]; then
    zsh_mode="enabled"
  else
    abort_script "Invalid Argument!" "" "Usage:" "  $(script_filename) [options]" "  -?, --help    show list of command-line options"
  fi
done

# Begin setting file permissions
print_stage "Setting file permissions"

# Alacritty
if [[ "${argument_flag}" == "false" || "${alacritty_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "640" "${HOME}/.dotfiles/alacritty"
fi

# Fonts
if [[ "${argument_flag}" == "false" || "${fonts_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/fonts"
fi

# Git
if [[ "${argument_flag}" == "false" || "${git_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "664" "${HOME}/.dotfiles/git"
fi

# Gnome
if [[ "${argument_flag}" == "false" || "${gnome_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "664" "${HOME}/.dotfiles/gnome"
fi

# Hardware
if [[ "${argument_flag}" == "false" || "${hardware_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/hardware"
fi

# Htop
if [[ "${argument_flag}" == "false" || "${htop_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "664" "${HOME}/.dotfiles/htop"
fi

# Projects
if [[ "${argument_flag}" == "false" || "${projects_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/projects"
fi

# Pulse
if [[ "${argument_flag}" == "false" || "${pulse_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/pulse"
fi

# Scripts
if [[ "${argument_flag}" == "false" || "${scripts_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "755" "${HOME}/.dotfiles/scripts"
fi

# Terminfo
if [[ "${argument_flag}" == "false" || "${terminfo_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "664" "${HOME}/.dotfiles/terminfo"
fi

# Tmux
if [[ "${argument_flag}" == "false" || "${tmux_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/tmux"
fi

# Udev
if [[ "${argument_flag}" == "false" || "${udev_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/udev"
fi

# Viddy
if [[ "${argument_flag}" == "false" || "${viddy_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "664" "${HOME}/.dotfiles/viddy"
fi

# Vim
if [[ "${argument_flag}" == "false" || "${vim_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/vim"
fi

# Zsh
if [[ "${argument_flag}" == "false" || "${zsh_mode}" == "enabled" ]]; then
  # Set permissions of all files in directory
  set_permissions "644" "${HOME}/.dotfiles/zsh"
fi
