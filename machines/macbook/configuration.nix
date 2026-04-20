{ pkgs, ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/diskConfig/single-disk-ext4-crypt.nix
  ];

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
