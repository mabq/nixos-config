{ lib, ... }:
{
  disko = {
    devices = {
      disk = {
        main = {
          type = "disk";
          device = lib.mkDefault "/dev/sda"; # Override this on each host
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
