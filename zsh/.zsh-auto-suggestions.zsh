# Extend suggestions beyond just previous command history
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# Make suggestion lookup async
export ZSH_AUTOSUGGEST_USE_ASYNC="true"

# This speeds up pasting
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N
  self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
