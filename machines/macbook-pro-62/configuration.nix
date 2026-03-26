{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared-defaults.nix
    ../../modules/network/systemd-networkd.nix
  ];

  # ---

  system.stateVersion = "25.11"; # [1]

  # [1] The installation version - used to maintain compatibility with
  # application data (e.g. databases) created on older NixOS versions.
  # The only time you should change this value is when re-installing NixOS
  # on this particular machine with a newer version of NixOS.
}
