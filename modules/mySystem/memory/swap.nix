# This module enables a swap file of 4Gb for all machines by default.
#
# You can completely disable this on per-machin basis using:
#   mySystem.memory.swap.enable = false;
#
# Or adjust the file size using the swapDevices module, e.g:
#   swapDevices.size = 8 * 1024;

{ config, lib, ... }:
with lib;
{
  options.mySystem.memory.swap = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable swap file.";
    };
  };

  config = mkIf config.mySystem.memory.swap.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = mkdefault 4 * 1024; # Adjust this on per-machine basis - NixOS expects the value in MB.
        priority = 5; # Lower priority than zram swap - lower number means lower priority
      }
    ];
  };
}
