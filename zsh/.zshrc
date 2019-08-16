# @todo Improve Tmux Session Algorithm
# @body Optimize the algorithm so the session starts as fast as possible, and improve reliablity for edge cases like resuming session with multiple clients still connected.
# Automatically use tmux in local sessions
if [ -z ${SSH_CLIENT+x} ]; then
  # Check if current shell session is in a tmux process
  if [ -z "$TMUX" ]; then
    # Create a new session if it does not exist
    base_session=$USER
    tmux has-session -t $base_session"-1" || tmux new-session -d -s $base_session"-1" \; set-window-option -g aggressive-resize

    # Check if clients are connected to session
    client_cnt=$(tmux list-clients | wc -l)
    if [ $client_cnt -ge 1 ]; then
      # Find unused client id
      count=1
      while [[ `tmux list-clients | grep $base_session"-"$count` != "" ]]
      do
        count=$((count+1))
      done
      session_name=$base_session"-"$count

      # Attach to current session as new client
      tmux new-session -d -t $base_session"-1" -s $session_name
      tmux -2 attach-session -t $session_name \; set-option destroy-unattached \; set-window-option -g aggressive-resize \; new-window; exit
    else
      # Attach to pre-existing session as previous client
      tmux -2 attach-session -t $base_session"-1" \; set-window-option -g aggressive-resize; exit
    fi
  fi
fi

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export TERM="screen-256color"

# Hide "user@hostname" info when you're logged in as yourself on your local machine.
DEFAULT_USER=$USER

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=powerlevel10k/powerlevel10k

# Syntax Highlighter Configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# @todo Revise Oh-My-Zsh Plugins
# @body Speed up shell operation and startup by removing unnecessary plugins.
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  colored-man-pages
  command-not-found
  extract
  fzf
  history-substring-search
  mosh
  nmap
  per-directory-history
  thefuck
  vscode
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# @todo Create FZF Config
# @body Create FZF specific config file to load.
# FZF Configuration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# @todo Fix Project-Configs Algorithm
# @body Fix the algorithm so it allows for an empty project-configs folder, and creates it if it does not exist. Potentially eliminate the project-configs folder entirely by dynamically loading unloading per-project configs from the project's directory.
# Source necessary files
source ~/.config/user-configs/aliases/.alias
for f in ~/.config/project-configs/.*; do source $f; done

# Enable fuzzy auto-completions
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# Enable partial auto-completions
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# To customize prompt, run `p10k configure` or edit ~/.config/user-configs/zsh/.p10k.zsh.
[[ -f ~/.config/user-configs/zsh/.p10k.zsh ]] && source ~/.config/user-configs/zsh/.p10k.zsh
