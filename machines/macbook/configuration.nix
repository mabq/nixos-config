{ pkgs, ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/disk/disko-uefi-luks.nix
  ];

  mySystem.network.networkd.enable = true;

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
