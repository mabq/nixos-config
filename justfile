xps:
  sudo nixos-rebuild --verbose switch --flake ~/.local/share/nixos-config/flake.nix#xps

rebuild config:
  sudo nixos-rebuild --verbose switch --flake .#{{config}}

fetch:
  git fetch origin
  git reset --hard origin/main
