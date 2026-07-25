# Encryption password is prompted at installation
{ lib, ... }:
{
  disko = {
    devices = {
      disk = {
        main = {
          type = "disk";
          device = lib.mkDefault "/dev/sda"; # override on each host
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ]; # readable only by root!
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  settings.allowDiscards = lib.mkDefault true;
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
  };
}
