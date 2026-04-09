{ lib, pkgs, ... }:
{
  # Enable the Bluetooth service
  hardware.bluetooth = {
    enable = lib.mkDefault true;
    powerOnBoot = lib.mkDefault true; # Powers up the controller on boot
    settings = {
      General = {
        # Shows battery charge of connected devices
        Experimental = lib.mkDefault true;
      };
    };
  };

  # Install bluetui for managing connections
  environment.systemPackages = with pkgs; [
    bluetui # TUI for managing bluetooth on Linux
  ];
}

