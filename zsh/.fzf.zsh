# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

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

# @todo Clean-up FZF Config
# @body Eliminate the duplicate color and default option definitions.

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
local command="${1}"
shift

local color00='#2d2d2d'
local color01='#393939'
local color02='#515151'
local color03='#747369'
local color04='#a09f93'
local color05='#d3d0c8'
local color06='#e8e6df'
local color07='#f2f0ec'
local color08='#f2777a'
local color09='#f99157'
local color0A='#ffcc66'
local color0B='#99cc99'
local color0C='#66cccc'
local color0D='#6699cc'
local color0E='#cc99cc'
local color0F='#d27b53'

export FZF_DEFAULT_OPTS="
--color=bg:${color00},bg+:${color01}
--color=fg:${color04},fg+:${color06}
--color=hl:${color0D},hl+:${color0D}
--color=prompt:${color0A}
--color=pointer:${color0C}
--color=marker:${color0C}
--color=spinner:${color0C}
--color=header:${color0D}
--color=info:${color0A}
--color=preview-bg:${color00}
--height 70%
--layout reverse
--border
"

case "${command}" in
  cd)           fzf "${@}" --preview 'tree -C {} | head -200' --preview-window right:60%:border ;;
  export|unset) fzf "${@}" --preview "eval 'echo \$'{}" --preview-window right:60%:border ;;
  ssh)          fzf "${@}" --preview 'dig {}' --preview-window right:60%:border ;;
  *)            fzf "${@}" --info inline --preview 'bat --style=numbers --color=always {} | head -500' --preview-window right:60%:border ;;
esac
}

# Base16 Eighties
# Author: Chris Kempson (http://chriskempson.com)
_gen_fzf_default_opts() {
local color00='#2d2d2d'
local color01='#393939'
local color02='#515151'
local color03='#747369'
local color04='#a09f93'
local color05='#d3d0c8'
local color06='#e8e6df'
local color07='#f2f0ec'
local color08='#f2777a'
local color09='#f99157'
local color0A='#ffcc66'
local color0B='#99cc99'
local color0C='#66cccc'
local color0D='#6699cc'
local color0E='#cc99cc'
local color0F='#d27b53'

export FZF_DEFAULT_OPTS="
--color=bg:${color00},bg+:${color01}
--color=fg:${color04},fg+:${color06}
--color=hl:${color0D},hl+:${color0D}
--color=prompt:${color0A}
--color=pointer:${color0C}
--color=marker:${color0C}
--color=spinner:${color0C}
--color=header:${color0D}
--color=info:${color0A}
--color=preview-bg:${color00}
"
}

# Configure default settings
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
${FZF_DEFAULT_OPTS}
--height 70%
--layout reverse
--border
"

# Configure CTRL+T settings
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="
${FZF_DEFAULT_OPTS}
--info inline
--preview 'bat --style=numbers --color=always {} | head -500'
--preview-window right:60%:border
--select-1
--exit-0
"
