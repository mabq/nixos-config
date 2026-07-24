{ ... }: {
  imports = [
    # this will change whenever you regenerate config file or when reinstalling the system
    ./hardware-configuration/XPS-1340-20260723.nix

    # or user disko + facter when using nixos-anywhere
    # ./disko/ext4.nix
  ];

  # this will only change if you replace the disk on the machine
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # disko.devices.disk.main.device = "/dev/sda";
  # hardware.facter.reportPath = ../facter/${hardware-configuration}.json;
}
