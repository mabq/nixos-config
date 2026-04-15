{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    # ../../modules/bluetooth.nix
    # ../../modules/pipewire.nix
  ];

  mySystem.memory.swap.enable = false;
  mySystem.network.manager = "networkmanager";

  system.stateVersion = "25.11"; # [1]

  # [1] The installation version - used to maintain compatibility with
  # application data (e.g. databases) created on older NixOS versions.
  # The only time you should change this value is when re-installing NixOS
  # on this particular machine with a newer version of NixOS.
}
