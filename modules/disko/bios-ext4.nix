{ lib, ... }:
with lib;
{
  disko = {
    devices = {
      disk = {
        main = {
          device = mkDefault "/dev/sda"; # Override this on each machine configuration file if necessary.
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              # GRUB stores its core image here when booting in legacy BIOS mode from a GPT disk
              boot = {
                size = "1M";
                type = "EF02";
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}
