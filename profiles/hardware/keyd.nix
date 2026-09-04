{
  configName,
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
  # Cannot use absolute path here. Keyd config files go into `/etc/keyd` so we
  # cannot use `mkOutOfStoreSymlink` (home-manager) with an absolute path.
  # We can derive an absolute path from the flake root to avoid breaking the
  # path if we move this module.
  # _repoConfigDir = self + (lib.strings.removePrefix "${repoDir}" "${repoConfigDir}");
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

    # etc."keyd".source = "${_repoConfigDir}/keyd/${configName}";
    etc."keyd".source = "../../config/keyd/${configName}";
  };
}
