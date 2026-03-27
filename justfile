update host:
  sudo git fetch origin
  sudo git reset --hard origin/main
  sudo nixos-rebuild switch --flake . #{{host}}
