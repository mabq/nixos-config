{
  inputs,
  config,
  disk,
  ...
}:

# Manual installations --------------------------------------------------------

{
  imports = [
    ./hardware-configuration/xps-20260724.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;
}

# Nixos-anywhere --------------------------------------------------------------

# {
#   imports = [
#     # inputs.disko.nixosModules.disko
#     # ./disko/ext4-encrypted.nix

#     # If using `nixos-generate-config`
#     # ./hardware-configuration/xps-20260729.nix
#   ];
#
#   boot.loader.grub.enable = true;
#   boot.loader.grub.device = disk;
#
#   disko.devices.disk.main.device = disk;

#   # If using `nixos-facter`
#   hardware.facter.reportPath = ./facter/xps-20260829.json;
# }
