{ config, lib, pkgs, c, ... }: {
  imports = [ ./hardware-configuration.nix ../configuration.nix ];

  # Use this file for machine specific configurations, do not edit `hardware-configuration.nix`.

  swapDevices = [{
    device = "/.swapfile";
    size = 4096; # Size in MB (e.g., 4096MB = 4GB)
  }];

  # Prefer network manager over dhcp (mutually exclusive options in nixos).
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
}
