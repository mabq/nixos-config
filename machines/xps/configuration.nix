{ pkgs, ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/diskConfig/single-disk-ext4-crypt.nix
  ];

  disko.devices.disk.main.device = "/dev/sda";

  # What facter configures? -> https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/hardware/facter/facter.md#what-gets-configured-module-hardware-facter-features
  hardware.facter.reportPath = ./facter.json;
  hardware.facter.detected.dhcp.enable = false;
}
