{ pkgs, ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/disk/single-disk-ext4.nix
  ];

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
