{ ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/disk/uefi-gpt-ext4-luks.nix
  ];

  mySystem.network.networkd.enable = true;

  # Based on the facter report it tries to use GRUB, I want systemd-boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
