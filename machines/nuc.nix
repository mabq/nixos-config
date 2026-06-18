{ lib, pkgs, ... }: {
  imports = [
    ./defaults.nix
    ../modules/disko-uefi-ext4-encrypted.nix
    ../modules/network-networkd.nix
    ../modules/pipewire.nix
  ];

  disko.devices.disk.main.device = "/dev/sda";

  # Sometimes facter tries to use GRUB on UEFI systems, make sure it uses systemd-boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
