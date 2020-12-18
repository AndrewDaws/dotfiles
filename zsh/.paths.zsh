# Configure dotfiles path environment variables
script_name="$(basename "${0}")"

if [[ -d "${HOME}/.dotfiles" ]]; then
    # Save dotfiles directory to environment variables if directory exists
    export DOTFILES_PATH="${HOME}/.dotfiles"

    # Save dotfiles sub-directories to environment variables if directory exists
    [[ -d "${DOTFILES_PATH}/alacritty" ]] && export DOTFILES_ALACRITTY_PATH="${DOTFILES_PATH}/alacritty"
    [[ -d "${DOTFILES_PATH}/alias" ]] && export DOTFILES_ALIAS_PATH="${DOTFILES_PATH}/alias"
    [[ -d "${DOTFILES_PATH}/fonts" ]] && export DOTFILES_FONTS_PATH="${DOTFILES_PATH}/fonts"
    [[ -d "${DOTFILES_PATH}/git" ]] && export DOTFILES_GIT_PATH="${DOTFILES_PATH}/git"
    [[ -d "${DOTFILES_PATH}/gnome" ]] && export DOTFILES_GNOME_PATH="${DOTFILES_PATH}/gnome"
    [[ -d "${DOTFILES_PATH}/hardware" ]] && export DOTFILES_HARDWARE_PATH="${DOTFILES_PATH}/hardware"
    [[ -d "${DOTFILES_PATH}/projects" ]] && export DOTFILES_PROJECTS_PATH="${DOTFILES_PATH}/projects"
    [[ -d "${DOTFILES_PATH}/scripts" ]] && export DOTFILES_SCRIPTS_PATH="${DOTFILES_PATH}/scripts"
    [[ -d "${DOTFILES_PATH}/term" ]] && export DOTFILES_TERM_PATH="${DOTFILES_PATH}/term"
    [[ -d "${DOTFILES_PATH}/tmux" ]] && export DOTFILES_TMUX_PATH="${DOTFILES_PATH}/tmux"
    [[ -d "${DOTFILES_PATH}/vim" ]] && export DOTFILES_VIM_PATH="${DOTFILES_PATH}/vim"
    [[ -d "${DOTFILES_PATH}/zsh" ]] && export DOTFILES_ZSH_PATH="${DOTFILES_PATH}/zsh"
else
    echo "Aborting ${script_name}"
    echo "    Directory ${HOME}/.dotfiles Does Not Exist!"
    exit 1
fi
