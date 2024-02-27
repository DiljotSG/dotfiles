#!/bin/zsh

if [[ $(uname -m) == 'arm64' ]]; then
  ln -s ~/dotfiles/zshrc_as ~/.zshrc
  exit
fi

ln -s ~/dotfiles/zshrc ~/.zshrc
