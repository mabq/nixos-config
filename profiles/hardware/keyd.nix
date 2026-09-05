{
  configName ? "default",
}:
{
  self,
  pkgs,
  user,
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

    # Keyd config files live in the `/etc` directory, so we cannot use
    # `mkOutOfStoreSymlink` with an absolute path.
    etc."keyd".source = self + repoConfigDir + "/keyd/${configName}";
  };
}
