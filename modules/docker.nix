{
  lib,
  pkgs,
  user,
  ...
}:
with lib; {
  environment.systemPackages = [
    pkgs.lazydocker # Simple terminal UI for both docker and docker-compose
  ];
  virtualisation.docker.enable = mkDefault true;
  users.users.${user}.extraGroups = ["docker"];
}
