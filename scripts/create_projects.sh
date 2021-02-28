#!/bin/bash
# Creates the projects config template file.
script_name="$(basename "${0}")"

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
} >"${HOME}/.dotfiles/projects/.projects"

chmod 644 "${HOME}/.dotfiles/projects/.projects"

echo "Created a projects source file for managing"
echo "project-specific configs which can be found at:"
echo "  ${HOME}/.dotfiles/projects/.projects"

exit 0
