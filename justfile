rebuild:
  # git fetch origin
  # git reset --hard origin/main
  sudo nixos-rebuild --verbose switch --flake .
  # nixos-theme-set-dconf

fetch:
  git fetch origin
  git reset --hard origin/main
