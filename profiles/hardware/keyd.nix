# This module uses a relative path to target its config directory, it you move
# it it will break.
{
  configName ? "default",
}:
{
  self,
  lib,
  pkgs,
  user,
  repoDir,
  repoConfigDir,
  ...
}:
{
  # Keyd is a system-level service
  services.keyd.enable = true;

  # User must be a member of this group
  users.users.${user}.extraGroups = [ "keyd" ];

  environment = {
    systemPackages = [
      # The package provides the `keyd` command (not included by enabling the service)
      pkgs.keyd # Key remapping daemon for Linux
    ];

    etc."keyd".source =
      self + lib.strings.removePrefix "${repoDir}" repoConfigDir + "/keyd/${configName}";
  };
}
