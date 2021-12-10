# Set default flags
alias rsync="\rsync \
  --human-readable \
  --info=progress2 \
  "

# Aliases
alias backup="rsync \
  --archive \
  --compress \
  --delete-during \
  "
