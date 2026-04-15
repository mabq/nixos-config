# Once the given percentage of physical memory is used, the system will start
# compressing data in ram. Compression ratio goes between 2:1 to 3:1, which
# allows you to store much more data in fast ram before needed to use the
# swap file, reducing the wear and tear of your SSD.
#
# Run `zramctl` to check how good memory is compressed.
#
# The time it takes for the CPU to compress/decompress data is negligent
# compared to the time it takes to read swapped data even from the fastest
# SSDs.

{ config, lib, ... }:
with lib;
{
  options.mySystem.zramPercent = mkOption {
    type = types.addCheck types.int (n: n == 0 || (n >= 1 && n <= 100));
    default = 50;
    description = mdDoc ''
      Percentage of total memory that can be stored in the zram swap devices.
      Default: 50.
      Valid values: 0 (disabled) or 1–100.
    '';
    example = 80;
  };

  config = mkIf (config.mySystem.zramPercent > 0) {
    zramSwap = {
      enable = true;
      memoryPercent = config.mySystem.zramPercent;
      priority = 100; # higher number means higher priority - give it higher priority than swap file
    };
  };
}
