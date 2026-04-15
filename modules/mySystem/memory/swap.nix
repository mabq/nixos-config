# Enable/disable this on per-machine basis using `mySystem.memory.swap.enable`.
#
# Adjust swap file size using `swapDevices.size = X * 1024;`.

{ config, lib, ... }:
with lib;
{
  options.mySystem.memory.swap.enable = mkEnableOption "Enable swap file.";

  config = mkIf config.mySystem.memory.swap.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = mkDefault (8 * 1024); # Adjust this on per-machine basis - NixOS expects the value in MB.
        priority = 5; # Lower priority than zram swap - lower number means lower priority
      }
    ];
  };
}
