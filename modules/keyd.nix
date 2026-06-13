{ lib, pkgs, user, ... }:
with lib; {
  services.keyd.enable = mkDefault true;

  environment = {
    systemPackages = [
      # Required to install the `keyd` command.
      pkgs.keyd # Key remapping daemon for Linux
    ];

    # This a nixos module, mkOutOfStoreSymlink is a Home-manager function, so we cannot use it here.
    etc."keyd".source = mkDefault ../users/${user}/config/keyd;
  };

  users.users.${user}.extraGroups = ["keyd"];
}
