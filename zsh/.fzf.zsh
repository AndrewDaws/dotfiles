# Set default options
FZF_DEFAULT_OPTS_LOCAL_VARIABLE="
  --height=70%
  --border
  --color=bg:#2d2d2d,bg+:#393939
  --color=fg:#a09f93,fg+:#e8e6df
  --color=hl:#6699cc,hl+:#6699cc
  --color=prompt:#ffcc66
  --color=pointer:#66cccc
  --color=marker:#66cccc
  --color=spinner:#66cccc
  --color=header:#6699cc
  --color=info:#ffcc66
  --color=preview-bg:#2d2d2d
  --layout=reverse
  --info=inline
  --preview-window=right:60%:border
  --select-1
  --exit-0
  "

export FZF_COMPLETION_OPTS='+c -x'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  ${FZF_DEFAULT_OPTS}
  ${FZF_DEFAULT_OPTS_LOCAL_VARIABLE}
  "

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="
  ${FZF_DEFAULT_OPTS}
  --preview='bat --style=numbers --color=always {} | head -500'
  "

# Modify functions
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "${1}"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "${1}"
}

_gen_fzf_default_opts() {
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS_LOCAL_VARIABLE}"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command="${1}"
  shift

  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS_LOCAL_VARIABLE}"

  case "${command}" in
    cd)                 fzf "${@}" --preview='exa --color=always --color-scale --git --classify --icons --tree --level=1 {}' ;;
    cat|bat|more|less)  fzf "${@}" --preview='[[ -d {} ]] && exa --color=always --color-scale --git --classify --icons --tree --level=1 {} || bat --style=numbers --color=always {} | head -500' ;;
    export|unset)       fzf "${@}" --preview="eval 'echo \$'{}" ;;
    ssh)                fzf "${@}" --preview='dig {}' ;;
    *)                  fzf "${@}" ;;
  esac
}
