{ ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/disk/bios-gpt-ext4-luks.nix
  ];

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
