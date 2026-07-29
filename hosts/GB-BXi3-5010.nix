{ hardware-configuration, ... }: {
  disko.devices.disk.main.device = "/dev/sda";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.facter.reportPath = ../facter/${hardware-configuration}.json;
}
