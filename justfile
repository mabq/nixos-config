xps:
  sudo nixos-rebuild --verbose --show-trace switch --flake .#xps

nr config:
  sudo nixos-rebuild --verbose --show-trace switch --flake .#{{config}}

fetch:
  git fetch origin
  git reset --hard origin/main
