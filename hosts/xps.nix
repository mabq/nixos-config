{ inputs, disk, ... }:

# Manual installations --------------------------------------------------------

# {
#   imports = [
#     ./hardware-configuration/xps-20260724.nix
#   ];
#
#   boot.loader.grub.enable = true;
#   boot.loader.grub.device = disk;
# }

# Nixos-anywhere --------------------------------------------------------------

{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko/ext4-encrypted.nix
  ];
  disko.devices.disk.main.device = disk;
  hardware.facter.reportPath = ./facter/xps-20260829.json;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;
}
