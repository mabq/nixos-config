rebuild:
  git fetch origin
  git reset --hard origin/main
  sudo nixos-rebuild switch --flake .
