# This module enables zram swap for all machines by default.
#
# You can completely disable this on per-machin basis using:
#   mySystem.memory.zram.enable = false;
#
# Or adjust the compression algorithm or memoryPercent using the zram module, e.g:
#   zramSwap.memoryPercent = 20;
#   zramSwap.algorithm = "zstd";
#
# Zram is often 10-100x faster than accessing a traditional swap file on an SSD.
#
# Use `zramctl` to check how good memory is compressed. The "DATA" field shows
# uncompressed data size, "COMPR" shows the compressed data size.
#
# Use `swapon --show` to check the priority of the zram device relative to any
# physical swap files or partitions you might have.

{ config, lib, ... }:
with lib;
{
  options.mySystem.memory.zram = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable in-memory compressed devices and swap space provided by the zram kernel module.";
    };
  };

  config = mkIf config.mySystem.memory.zram.enable {
    zramSwap = {
      enable = mkDefault true;
      memoryPercent = mkDefault 50; # Adjust this on per-machine basis.

      #                    lz4             zstd
      # Compression ratio  ~2.5-2.8:1      ~3.5-4:1
      # CPU usage          lower           higher
      # Speed              2.5x faster     2.5x slower
      algorithm = mkDefault "lz4"; # On machines with newer processors, you can change this to `zstd` for better compression

      priority = 100; # Higher priority than swap file - higher number means higher priority
    };
  };
}
