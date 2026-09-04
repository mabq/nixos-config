# TIP: Before using this module try enabling zram.
{ lib, ... }:
with lib;
{
  swapDevices = [
    {
      size = mkDefault (8 * 1024); # size in MB

      device = "/var/lib/swapfile";
      priority = 5; # lower priority than zram
    }
  ];
}
