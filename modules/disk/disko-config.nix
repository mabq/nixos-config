{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {

            # Required for GRUB on GPT + BIOS systems.
            # 1 MiB, unformatted — GRUB writes its second-stage bootloader here.
            # Replaces the ESP from the UEFI version; no filesystem or mountpoint.
            BIOS = {
              size     = "1MiB";
              type     = "EF02";  # BIOS Boot partition GUID
              priority = 1;       # placed first on the disk
            };

            # Unencrypted /boot — GRUB must read the kernel and initrd
            # from here before it can unlock the LUKS container.
            # Replaces the ESP from the UEFI version.
            boot = {
              size = "500M";
              content = {
                type       = "filesystem";
                format     = "ext4";  # ext4 instead of vfat — no UEFI requirement here
                mountpoint = "/boot";
              };
            };

            # LUKS encrypted root partition — identical in structure to the
            # UEFI version, except LUKS1 is enforced because GRUB cannot
            # decrypt LUKS2 at boot time.
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraFormatArgs   = [ "--type" "luks1" ]; # GRUB does not support LUKS2
                settings.allowDiscards = true;
                passwordFile = "/tmp/secret.key";
                content = {
                  type       = "filesystem";
                  format     = "ext4";
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
