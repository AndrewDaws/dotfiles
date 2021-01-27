#!/bin/bash

# @todo Preserve Git Config
# @body Preserve an existing .gitconfig and update with new settings.

rm -f "${HOME}/.gitconfig"
find "${DOTFILES_GIT_PATH}" -type f -exec chmod 664 {} \;
{
  echo "[include]"
  echo "  path = ${DOTFILES_GIT_PATH}/.gitconfig_global"
  echo ""
  echo "[core]"
  echo "  excludesfile = ${DOTFILES_GIT_PATH}/.gitignore_global"
  echo "  attributesfile = ${DOTFILES_GIT_PATH}/.gitattributes_global"
  echo ""
  echo "[user]"
} >>"${HOME}/.gitconfig"
echo 'What is your Git name?'
read gitName
echo "  name = ${gitName}" >>"${HOME}/.gitconfig"
echo 'What is your Git email?'
read gitEmail
echo "  email = ${gitEmail}" >>"${HOME}/.gitconfig"
chmod 664 "${HOME}/.gitconfig"
