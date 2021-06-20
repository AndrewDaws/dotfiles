# Zsh options
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Fzf-tab options
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# Completions
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --color=always --color-scale --git --classify --icons --tree --level=1 ${realpath}'
