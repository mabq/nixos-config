# usage: just rebuild config
rebuild config:
  # git fetch origin
  # git reset --hard origin/main
  sudo nixos-rebuild --verbose switch --flake .#{{config}}

fetch:
  git fetch origin
  git reset --hard origin/main
