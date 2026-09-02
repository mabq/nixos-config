# Options inherent to this machine only!
{ host, ... }:
{
  imports = [
    ./modules/disko/ext4-encrypted.nix # disk layout
    ./modules/network/systemd-networkd.nix # network manager
  ];

  # The version of NixOS used for installation on this specific machine.
  # Set it once at installation time and never change it afterwards!
  system.stateVersion = "26.05";

  # Use `lsblk -o NAME,ID-LINK` to check device's wwn id
  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x5000cca55ff314ed";

  # Newer versions of NixOS could take better decisions (which kernel modules,
  # which options to use) based on the same hardware report.
  hardware.facter.reportPath = ./facter/${host}.json;

  boot.loader.grub.enable = true;
  # boot.loader.grub.device = (set by disko)
}
