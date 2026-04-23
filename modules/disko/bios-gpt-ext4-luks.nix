{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = lib.mkDefault "/dev/sda"; # Override on each machine config file where different
        content = {
          type = "gpt";
          partitions = {
            # Required for GRUB on GPT + BIOS systems. Replaces the ESP from 
            # he UEFI version; no filesystem or mountpoint.
            BIOS = {
              size = "1M";
              type = "EF02"; # BIOS Boot partition GUID
              priority = 1;
            };
            # Unencrypted /boot — GRUB must read the kernel and initrd from
            # here before it can unlock the LUKS container. Replaces the ESP
            # from the UEFI version.
            boot = {
              size = "500M";
              priority = 2;
              content = {
                type = "filesystem";
                format = "ext4"; # ext4 instead of vfat — no UEFI requirement here.
                mountpoint = "/boot";
              };
            };
            # LUKS encrypted root partition — identical in structure to the
            # UEFI version, except LUKS1 is enforced because GRUB cannot
            # decrypt LUKS2 at boot time.
            luks = {
              size = "100%";
              priority = 3;
              content = {
                type = "luks";
                name = "crypted";
                extraFormatArgs = [ "--type" "luks1" ]; # GRUB does not support LUKS2.
                settings.allowDiscards = lib.mkDefault true; # Keep it if you need SSD performance/longevity. Remove it if you require maximum security and can accept performance degradation.
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
