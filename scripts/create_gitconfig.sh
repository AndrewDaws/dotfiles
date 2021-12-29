#!/bin/bash

# @todo Preserve Git Config
# @body Preserve an existing .gitconfig and update with new settings.

rm -f "${HOME}/.gitconfig"
find "${HOME}/.dotfiles/git" -type f -exec chmod 664 {} \;
{
  echo "[include]"
  echo "  path = ~/.dotfiles/git/.gitconfig_global"
  echo ""
  echo "[core]"
  echo "  excludesfile = ~/.dotfiles/git/.gitignore_global"
  echo "  attributesfile = ~/.dotfiles/git/.gitattributes_global"
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
