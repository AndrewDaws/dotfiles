#!usr/bin/env zsh

# - - - - - - - - - - - - - - - - - - - -
# Terminal
# - - - - - - - - - - - - - - - - - - - -

# Set default terminal
if [[ -f "${HOME}/.terminfo/x/xterm-256color-italic" ]]; then
  export TERM="xterm-256color-italic"
else
  export TERM="xterm-256color"
fi


# - - - - - - - - - - - - - - - - - - - -
# Tmux
# - - - - - - - - - - - - - - - - - - - -

# @todo Improve Tmux Session Algorithm
# @body Optimize the algorithm so the session starts as fast as possible, and improve reliablity for edge cases like resuming session with multiple clients still connected.
# Check if current shell session is in a tmux process
if [[ -z "${TMUX}" ]]; then
  # Tmux banned applications list
  TMUX_BANNED_APPS=(
    vscode
  )

  # Ignore terminals started inside specific applications
  if [[ ! "${TMUX_BANNED_APPS[*]}" == "${TERM_PROGRAM}" ]]; then
    # Check if Tmux is installed
    if command -v -- "tmux" &>/dev/null; then
      TMUX_SESSION_BASE="Local"
      TMUX_SESSION_NUMBER="1"
      TMUX_SESSION_CLIENTS="$(tmux list-clients | wc -l)"
      TMUX_SESSION_WINDOWS="1"

      # Do not use Tmux if SSH client
      if [[ -z "${SSH_CLIENT}" ]]; then
        # Create a new session if it does not exist
        if tmux -2 has-session -t "1  ${TMUX_SESSION_BASE}"; then
          # Check if clients are connected to session
          if [[ "${TMUX_SESSION_CLIENTS}" -ge 1 ]]; then
            # Find unused client id
            while [[ -n "$(tmux list-clients -t "${TMUX_SESSION_NUMBER}  ${TMUX_SESSION_BASE}")" ]]; do
              TMUX_SESSION_NUMBER="$((TMUX_SESSION_NUMBER+1))"
            done

            # Check how many windows exist in session
            TMUX_SESSION_WINDOWS="$(tmux list-windows -t "${TMUX_SESSION_NUMBER}  ${TMUX_SESSION_BASE}" -F '#{session_windows}' | wc -l)"

            # Attach to current session as new client
            tmux -2 new-session -d -t "1  ${TMUX_SESSION_BASE}" -s "${TMUX_SESSION_NUMBER}  ${TMUX_SESSION_BASE}"
            tmux -2 attach-session -t "${TMUX_SESSION_NUMBER}  ${TMUX_SESSION_BASE}" \; set-option destroy-unattached \; set-window-option -g aggressive-resize \; new-window
            exit
          else
            # Attach to pre-existing session as previous client
            tmux -2 attach-session -t "1  ${TMUX_SESSION_BASE}" \; set-window-option -g aggressive-resize
            exit
          fi
        else
          tmux -2 new-session -s "1  ${TMUX_SESSION_BASE}" \; set-window-option -g aggressive-resize
          exit
        fi
      fi
    fi
  fi
fi


# - - - - - - - - - - - - - - - - - - - -
# Instant Prompt
# - - - - - - - - - - - - - - - - - - - -

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# - - - - - - - - - - - - - - - - - - - -
# Zsh Core Configuration
# - - - - - - - - - - - - - - - - - - - -

# Install functions
export XDG_CONFIG_HOME="${HOME}/.config"
export UPDATE_INTERVAL="15"

export DOTFILES="${HOME}/.dotfiles"
export ZSH="${DOTFILES}/zsh"

# Load the prompt system and completion system
autoload -Uz compinit promptinit

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day
# See: https://gist.github.com/ctechols/ca1035271ad134841284
_comp_files=(${ZDOTDIR:-${HOME}}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files
promptinit
setopt prompt_subst


# - - - - - - - - - - - - - - - - - - - -
# ZSH Settings
# - - - - - - - - - - - - - - - - - - - -

autoload -U colors && colors # Load colors
unsetopt case_glob           # Use case-insensitve globbing
setopt globdots              # Glob dotfiles
setopt extendedglob          # Use extended globbing
setopt autocd                # Automatically change directory if a directory is entered

# Smart URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General
setopt brace_ccl       # Allow brace character class list expansion
setopt combining_chars # Combine zero-length punctuation characters ( accents ) with the base character
setopt rc_quotes       # Allow 'henry''s garage' instead of 'henry'\''s garage'
unsetopt mail_warning  # Don't print a warning message if a mail file has been accessed

# Jobs
setopt long_list_jobs # List jobs in the long format by default
setopt auto_resume    # Attempt to resume existing job before creating a new process
setopt notify         # Report status of background jobs immediately
unsetopt bg_nice      # Don't run all background jobs at a lower priority
unsetopt hup          # Don't kill jobs on shell exit
unsetopt check_jobs   # Don't report on jobs when shell exit

# setopt correct # Turn on corrections

# Completion options
setopt complete_in_word    # Complete from both ends of a word
setopt always_to_end       # Move cursor to the end of a completed word
setopt path_dirs           # Perform path search even on command names with slashes
setopt auto_menu           # Show completion menu on a successive tab press
setopt auto_list           # Automatically list choices on ambiguous completion
setopt auto_param_slash    # If completed parameter is a directory, add a trailing slash
setopt no_complete_aliases

setopt menu_complete  # Do not autoselect the first completion entry
unsetopt flow_control # Disable start/stop characters in shell editor


# Zstyle
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' rehash true
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
# zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
# zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
# zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
# zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${HOME}/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z\-}={A-Z\_}' 'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' 'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# History
HISTFILE="${ZDOTDIR:-${HOME}}/.zhistory"
HISTSIZE="100000"
SAVEHIST="5000"
setopt appendhistory notify
unsetopt beep nomatch

setopt bang_hist              # Treat the '!' character specially during expansion
setopt inc_append_history     # Write to the history file immediately, not when the shell exits
setopt share_history          # Share history between all sessions
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history
setopt hist_ignore_dups       # Do not record an event that was just recorded again
setopt hist_ignore_all_dups   # Delete an old recorded event if a new event is a duplicate
setopt hist_find_no_dups      # Do not display a previously found event
setopt hist_ignore_space      # Do not record an event starting with a space
setopt hist_reduce_blanks     # Remove superfluous blanks from commands added to history
setopt hist_save_no_dups      # Do not write a duplicate event to the history file
setopt hist_verify            # Do not execute immediately upon history expansion
setopt extended_history       # Show timestamp in history

zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 } # Do not store failed commands to history

# - - - - - - - - - - - - - - - - - - - -
# Zinit Configuration
# - - - - - - - - - - - - - - - - - - - -

__ZINIT="${ZDOTDIR:-${HOME}}/.zinit/bin/zinit.zsh"

if [[ ! -f "${__ZINIT}" ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma-continuum/zinit)…%f"
  command mkdir -p "${HOME}/.zinit" && command chmod g-rwX "${HOME}/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "${HOME}/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

. "${__ZINIT}"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most themes use this option
setopt promptsubst

# Provide a simple prompt till the theme loads
PS1=">"
zinit ice depth"1" lucid atload'export ZLE_RPROMPT_INDENT=0; source ${ZSH}/.p10k.zsh' nocd
zinit light romkatv/powerlevel10k


# - - - - - - - - - - - - - - - - - - - -
# Annexes
# - - - - - - - - - - - - - - - - - - - -

# Load a few important annexes, without turbo (this is currently required for annexes)
zinit light-mode compile"handler" for \
  zdharma-continuum/z-a-patch-dl \
  zdharma-continuum/z-a-as-monitor \
  zdharma-continuum/z-a-bin-gem-node \
  zdharma-continuum/z-a-submods \
  zdharma-continuum/declare-zsh


# - - - - - - - - - - - - - - - - - - - -
# Programs
# - - - - - - - - - - - - - - - - - - - -

# junegunn/fzf
zinit ice wait"0b" lucid from"gh-r" as"program" pick"fzf" atload"source ${ZSH}/.fzf.zsh"
zinit light junegunn/fzf

zinit ice wait"0c" lucid as"program" id-as"junegunn/fzf_completions" pick"bin/fzf-tmux"
zinit light junegunn/fzf

zinit ice wait"0c" lucid id-as"junegunn/fzf_completions" pick"/dev/null" multisrc"shell/{completion,key-bindings}.zsh"
zinit light junegunn/fzf

# sharkdp/fd
zinit ice wait"1" lucid as"program" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# BurntSushi/ripgrep
zinit ice wait"2" lucid as"program" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zinit light BurntSushi/ripgrep

# sharkdp/bat
zinit ice wait"1" lucid as"program" from"gh-r" mv"bat* -> bat" pick"bat/bat" atload"source ${ZSH}/.bat.zsh"
zinit light sharkdp/bat

# dandavision/delta
zinit ice wait"2" lucid as"program" from"gh-r" mv"delta* -> delta" pick"delta/delta"
zinit light dandavison/delta

# ogham/exa
zinit ice wait lucid as"program" from"gh-r" pick"bin/exa" atload"source ${ZSH}/.exa.zsh"
zinit light ogham/exa

# github/hub
zinit ice wait"3" lucid as"program" from"gh-r" mv"hub* -> hub" pick"hub/bin/hub" atload"source ${ZSH}/.hub.zsh"
zinit light github/hub

zplugin ice wait"3" lucid as"completion" mv'*ion -> _hub'
zplugin snippet https://github.com/github/hub/raw/master/etc/hub.zsh_completion


# - - - - - - - - - - - - - - - - - - - -
# Plugins
# - - - - - - - - - - - - - - - - - - - -

zinit wait lucid light-mode for \
    hlissner/zsh-autopair \
    jimhester/per-directory-history \
  atinit"zicompinit; zicdreplay" \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
    OMZ::plugins/sudo/sudo.plugin.zsh \
    zdharma-continuum/fast-syntax-highlighting

zinit ice wait"3" lucid atload"source ${ZSH}/.git-auto-fetch.zsh"
zinit snippet OMZ::plugins/git-auto-fetch/git-auto-fetch.plugin.zsh

zinit ice wait"1" lucid atload"source ${ZSH}/.zsh-z.zsh"
zinit light agkozak/zsh-z

zinit ice wait"1" lucid atload"source ${ZSH}/.zsh-history-substring-search.zsh"
zinit light zsh-users/zsh-history-substring-search

zinit ice wait"1" lucid atload"enable-fzf-tab; source ${ZSH}/.fzf-tab.zsh"
zinit light Aloxaf/fzf-tab

zinit ice wait lucid atload"_zsh_autosuggest_start; source ${ZSH}/.zsh-auto-suggestions.zsh"
zinit light zsh-users/zsh-autosuggestions

# Recommended to be loaded last
zinit ice wait blockf lucid atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions


# - - - - - - - - - - - - - - - - - - - -
# Aliases
# - - - - - - - - - - - - - - - - - - - -

[[ -f "${DOTFILES}/zsh/.alias.zsh" ]] && source "${DOTFILES}/zsh/.alias.zsh"


# - - - - - - - - - - - - - - - - - - - -
# Key bindings
# - - - - - - - - - - - - - - - - - - - -

[[ -f "${DOTFILES}/zsh/.key-binding.zsh" ]] && source "${DOTFILES}/zsh/.key-binding.zsh"


# - - - - - - - - - - - - - - - - - - - -
# Projects
# - - - - - - - - - - - - - - - - - - - -

# Project Configurations
if [[ -f "${HOME}/.dotfiles/projects/.projects" ]]; then
  source "${HOME}/.dotfiles/projects/.projects"
else
  "${HOME}/.dotfiles/scripts/create_projects.sh"
  source "${HOME}/.dotfiles/projects/.projects"
fi

# @todo Create Local Override Directory
# @body Add a gitignore'd folder to contain local logins, aliases, and configurations that override those included in this dotfiles repo.
