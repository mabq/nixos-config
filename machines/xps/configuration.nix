{ pkgs, ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/disk/disko-bios-luks.nix
  ];

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
