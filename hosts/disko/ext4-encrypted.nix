{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        # device = # don't set a default value to avoid accidental overrides
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              type = "EF02"; # for grub MBR
              size = "1M";
              priority = 1; # needs to be first partition
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ]; # readable only by root
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
}

/*
  Encryption password is prompted at installation.

  TRIM/discard tells an SSD which blocks are no longer in use so the drive can
  reclaim them (better performance + longevity). On encrypted or layered
  storage (LUKS, LVM, etc.), discards are disabled by default because they can
  leak information about which blocks are free. allowDiscards explicitly opts
  in to letting those commands through.
*/
