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
let
  # Avoid breaking this module if you move it or change the location of the
  # config directory inside this repo.
  configDir = self + lib.strings.removePrefix "${repoDir}" repoConfigDir;
in
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

    # Keyd config files live in the `/etc` directory, so we cannot use
    # `mkOutOfStoreSymlink` here with an absolute path.
    etc."keyd".source = configDir + "/keyd/${configName}";
  };
}
