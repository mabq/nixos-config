{
  config,
  # inputs,
  ...
}:
let
  disk = "/dev/sda";
in
{
  imports = [
    # When installing NixOS manually:
    ./hardware-configuration/xps-20260724.nix

    # When installing with nixos-anywhere:
    # inputs.disko.nixosModules.disko
    # ./disko/ext4-encrypted.nix
    # ./hardware-configuration/xps-20260729.nix # https://nix-community.github.io/nixos-anywhere/quickstart.html#8-prepare-hardware-configuration
  ];

  # When installing with nixos-anywhere:
  # disko.devices.disk.main.device = disk;
  # hardware.facter.reportPath = ./facter/xps-20260729.json; # https://nix-community.github.io/nixos-anywhere/quickstart.html#81-nixos-facter

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;
}

/*
  Disko configurations are used to partition the disk during installation and
  also to mount filessystems.

  See [Prepare Hardware Configuration](https://nix-community.github.io/nixos-anywhere/quickstart.html#8-prepare-hardware-configuration)
*/
