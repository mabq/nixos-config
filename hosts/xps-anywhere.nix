{ ... }:
let
  disk = "/dev/sda";
in
{
  imports = [
    ./disko/ext4-encrypted.nix
  ];

  disko.devices.disk.main.device = disk;

  # Configures hardware support
  hardware.facter.reportPath = ./facter/xps.json;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;

  networking.hostName = "xps";
}

/*
  Disko is used to partition the disk during installation and also to create
  configuration options for mount points.
*/
