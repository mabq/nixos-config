{ pkgs, ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/diskConfig/single-disk-ext4-crypt.nix
  ];

  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;

  disko.devices.disk.main.device = "/dev/sda";

  # This relative path refers to the directory on your source machine (the computer where you run the nixos-anywhere command).
  # The facter.json file is never "copied" as a loose file to the target machine. Instead, it is baked directly into the Nix Store on the target.
  hardware.facter.reportPath = ./facter.json;
  systemd.network.wait-online.enable = false;

  system.stateVersion = "25.11";
}
