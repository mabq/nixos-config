# Disk configuration compatible with both BIOS and EFI systems.
# https://github.com/nix-community/disko-templates/blob/main/single-disk-ext4/disko-config.nix
#
# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
#  disko.devices.disk.main.device = "/dev/sda";
# }
{lib, ...}:
{
  disko.devices = {
    disk = {
      main = {
        device = lib.mkDefault = "/dev/sda"; # change this on per-machine basis where different
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks"; # LUKS passphrase will be prompted interactively only
                name = "crypted";
                settings = {
                  allowDiscards = true;
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
