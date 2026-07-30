{ ... }: {
  imports = [
    ./hardware-configuration/xps-20260724.nix # change this on reinstall
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
}
