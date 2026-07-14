rebuild:
  # git fetch origin
  # git reset --hard origin/main
  sudo nixos-rebuild --verbose switch --flake .#workstation

fetch:
  git fetch origin
  git reset --hard origin/main
