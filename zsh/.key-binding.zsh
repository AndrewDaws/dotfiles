# Clear screen when enter is pressed with empty command
magic-enter () {
  if [[ -z "${BUFFER}" ]]; then
    zle clear-screen
  else
    zle accept-line
  fi
}
zle -N magic-enter
bindkey "^M" magic-enter
