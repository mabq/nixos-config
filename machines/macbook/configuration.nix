{ lib, ... }:
with lib;
{
  imports = [
    ../defaults.nix
    ../../modules/disko/uefi-gpt-ext4-luks.nix
  ];

  # Sometimes facter tries to use GRUB on UEFI systems, make sure it uses systemd-boot.
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  mySystem.network.networkd.enable = true;

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
