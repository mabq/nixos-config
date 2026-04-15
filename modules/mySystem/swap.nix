{ config, lib, ... }:
with lib;
{
  options.mySystem.swapSize = mkOption {
    type = types.addCheck types.int (n: n == 0 || (n >= 1 && n <= 64));
    default = 8;
    description = mdDoc ''
      Size of the swap file in gigabytes.
      Default: 8
      Valid values: 0 (disabled) or 1–64 GB.
    '';
    example = 16;
  };

  config = mkIf (config.mySystem.swapSize > 0) {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = config.mySystem.swapSize * 1024; # NixOS expects MB.
        priority = 5; # lower number means lower priority - give it lower priority than zram swap
      }
    ];
  };
}
