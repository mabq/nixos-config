{ ... }: {
  imports = [
    # this will change whenever you regenerate config file or when reinstalling the system
    ./hardware-configuration/xps-20260724.nix

    # or user disko + facter when using nixos-anywhere
    # inputs.disko.nixosModules.disko
    # ./disko/ext4.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # disko.devices.disk.main.device = "/dev/sda";
  # hardware.facter.reportPath = ../facter/${hardware-configuration}.json;

  networking.hostName = "xps";
}
