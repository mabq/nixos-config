{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../defaults.nix
    ../../modules/diskConfig/single-disk-ext4-crypt.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  disko.devices.disk.main.device = "/dev/sda";

  system.stateVersion = "25.11"; # [1]

  # [1] The installation version - used to maintain compatibility with
  # application data (e.g. databases) created on older NixOS versions.
  # The only time you should change this value is when re-installing NixOS
  # on this particular machine with a newer version of NixOS.
}
