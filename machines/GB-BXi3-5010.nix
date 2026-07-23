{ hardware-configuration, ... }: {
  # TODO: Is this set by facter modules?
  disko.devices.disk.main.device = "/dev/sda";

  # This automatically configures hardware based on facter report
  hardware.facter.reportPath = ../facter/${hardware-configuration}.json;

  # Sometimes facter tries to use GRUB on UEFI systems, make sure it uses systemd-boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
