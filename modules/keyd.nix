{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; {
  services.keyd.enable = mkDefault true;

  environment = {
    systemPackages = [
      pkgs.keyd # Key remapping daemon for Linux (required to have the `keyd` command)
    ];

    etc."keyd".source = ../config/keyd; # this a nixos module, we don't have the repo path here to create a outOfStore link.
  };

  users.users.${user}.extraGroups = ["keyd"];
}
