# README file in configuration files
{
  lib,
  pkgs,
  user,
  ...
}:
{
  services.keyd.enable = lib.mkDefault true;

  # User must be a member of this group
  users.users.${user}.extraGroups = [ "keyd" ];

  environment = {
    systemPackages = [
      pkgs.keyd # Key remapping daemon for Linux (required to use the `keyd` command)
    ];

    # Keyd config files are system-level — `mkOutOfStoreSymlink` is a
    # home-manager function that cannot be used here.
    etc."keyd".source = lib.mkDefault ../../../config/keyd;
  };
}
