{
  inputs,
  disk,
  ...
}:

# Manual installations --------------------------------------------------------

# {
#   imports = [
#     ./hardware-configuration.nix
#   ];
#
#   boot.loader.grub.enable = true;
#   boot.loader.grub.device = disk;
# }

# Nixos-anywhere --------------------------------------------------------------

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../modules/disko/ext4-encrypted.nix
  ];

  disko.devices.disk.main.device = disk; # https://nix-community.github.io/nixos-anywhere/quickstart.html#4-configure-storage
  hardware.facter.reportPath = ./facter.json; # https://nix-community.github.io/nixos-anywhere/quickstart.html#81-nixos-facter

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;
}
