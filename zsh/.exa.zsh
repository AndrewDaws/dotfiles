# Set default flags
alias exa="\exa \
  --classify \
  --color-scale \
  --color=always \
  --git \
  --icons \
  --time-style=long-iso \
  "

# Aliases

# List files and directories
alias l="exa \
  --git-ignore \
  --long \
  "

# List all files and directories (including hidden)
alias la="exa \
  --all \
  --long \
  "

# TODO Fix Exa File Aliases To Not Show Directories
# List files
alias lf="exa \
  --git-ignore \
  --long \
  "
# -l -- *(-.)

# List all files (including hidden)
alias lfa="exa \
  --all \
  --long \
  "

# List directories
alias ld="exa \
  --git-ignore \
  --long \
  --only-dirs \
  "

# List all directories (including hidden)
alias lda="exa \
  --all \
  --long \
  --only-dirs \
  "

# List files and directories with groups
alias lg="exa \
  --git-ignore \
  --group \
  --long \
  "

# List files and directories with groups (including hidden)
alias lga="exa \
  --all \
  --group \
  --long \
  "

# List ten most recently modified files and directories
lt() {
  exa \
    --git-ignore \
    --long \
    --reverse \
    --sort=newest \
    "${*}" | head -10
}

# List ten most recently modified files and directories (including hidden)
lta() {
  exa \
    --all \
    --long \
    --reverse \
    --sort=newest \
    "${*}" | head -10
}
