{ ... }:
{
  imports = [
    ../defaults.nix
    ../../modules/disko/bios-gpt-ext4.nix
  ];

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
