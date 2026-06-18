{
  lib,
  pkgs,
  user,
  ...
}:
with lib;
{
  virtualisation.docker.enable = mkDefault true;

  # User must be a member of this group
  users.users.${user}.extraGroups = [ "docker" ];

  environment.systemPackages = [
    pkgs.lazydocker # simple terminal UI for both docker and docker-compose
  ];
}
