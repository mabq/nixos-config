# This file is used by `nixos-anywhere` to partition, format, and mount the disks.
{ lib, ... }:
{
  disko = {
    devices = {
      disk = {
        main = {
          type = "disk";
          # device = (set on host file)
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

/*
  Encryption password is prompted at installation.

  TRIM/discard tells an SSD which blocks are no longer in use so the drive can
  reclaim them (better performance + longevity). On encrypted or layered
  storage (LUKS, LVM, etc.), discards are disabled by default because they can
  leak information about which blocks are free. allowDiscards explicitly opts
  in to letting those commands through.
*/
