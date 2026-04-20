{lib, ...}:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = lib.mkDefault "/dev/sda"; # change this on per-machine basis where different
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition (FAT32, ~512MB)
            ESP = {
              size = "512M";
              type = "EF00"; # # EFI System Partition GUID
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # Root partition (ext4, uses remaining space)
            root = {
              size = "100%";
              content = {
                type = "luks"; # LUKS passphrase will be prompted interactively only
                name = "crypted";
                settings = {
                  allowDiscards = true; # TRIM support for SSDs
                };
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
