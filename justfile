rebuild:
  # git fetch origin
  # git reset --hard origin/main
  sudo nixos-rebuild --verbose switch --flake .

fetch:
  git fetch origin
  git reset --hard origin/main
