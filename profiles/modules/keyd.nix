{
  configName,
}:
{
  lib,
  pkgs,
  user,
  ...
}:
{
  # Keyd is a system-level service
  services.keyd.enable = lib.mkDefault true;

  # User must be a member of this group
  users.users.${user}.extraGroups = [ "keyd" ];

  environment = {
    systemPackages = [
      # The package provides the `keyd` command (not included by enabling the service)
      pkgs.keyd # Key remapping daemon for Linux
    ];

    # `mkOutOfStoreSymlink` is a home-manager function that cannot be used here
    etc."keyd".source = lib.mkDefault ../../config/keyd/${configName};
  };
}
