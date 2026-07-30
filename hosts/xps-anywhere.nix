{ inputs, ... }:
let
  disk = "/dev/sda";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko/ext4-encrypted.nix
    ./hardware-configuration/xps-20260729.nix # created by `nixos-anywhere`
  ];

  disko.devices.disk.main.device = disk;

  # hardware.facter.reportPath = ./facter/xps-20260729.json;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;

  networking.hostName = "xps";
}

/*
  Disko is used to partition the disk during installation and also to create
  configuration options for mount points.
*/
