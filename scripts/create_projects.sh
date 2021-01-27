#!/bin/bash
# Creates the projects config template file.
script_name="$(basename "${0}")"

# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
  if [[ -f "${HOME}/.dotfiles/zsh/.paths.zsh" ]]; then
    source "${HOME}/.dotfiles/zsh/.paths.zsh"
  else
    echo "Aborting ${HOME}/.dotfiles/zsh/.paths.zsh"
    echo "  File ${HOME}/.dotfiles/zsh/.paths.zsh Does Not Exist!"
    exit 1
  fi
fi

# Create the projects config file
{
  echo "#!/bin/bash"
  echo "#"
  echo "# Please place your project-specific configs in"
  echo "# this directory and source those configs inside"
  echo "# this .projects file as shown below:"
  echo "#"
  echo "# WARNING: This directory and file are ignored by"
  echo "#          git, and thus you should not be reliant"
  echo "#          on this directory for backups. This is"
  echo "#          simply intended for easy management of"
  echo "#          all configs that are not intended to"
  echo "#          be a part of this dotfiles repository."
  echo ""
  echo "# source ".someproject""
  echo "# source "/some/path/.otherproject""
  echo ""
} >"${DOTFILES_PROJECTS_PATH}/.projects"

chmod 644 "${DOTFILES_PROJECTS_PATH}/.projects"

echo "Created a projects source file for managing"
echo "project-specific configs which can be found at:"
echo "  ${DOTFILES_PROJECTS_PATH}/.projects"

exit 0
