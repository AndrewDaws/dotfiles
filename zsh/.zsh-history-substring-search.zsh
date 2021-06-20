# Set global variables
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=8,fg=black'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=black,fg=red'
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true"
export HISTORY_SUBSTRING_SEARCH_FUZZY="true"

# Enable arrow keys up and down to go through matching command history
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
