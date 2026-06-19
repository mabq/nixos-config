# Read the README file in the configuration files!
{
  lib,
  pkgs,
  user,
  ...
}:
with lib;
{
  services.keyd.enable = mkDefault true;

  # User must be a member of this group
  users.users.${user}.extraGroups = [ "keyd" ];

  environment = {
    systemPackages = [
      pkgs.keyd # Key remapping daemon for Linux (required to use the `keyd` command)
    ];

    # Keyd config files cannot be put in the user's home directory.
    # `mkOutOfStoreSymlink` is a Home-manager function (cannot use it here).
    etc."keyd".source = mkDefault ../config/keyd;
  };
}
