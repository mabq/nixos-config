{ lib, pkgs, ... }:
{
  # Enable the Bluetooth service
  hardware.bluetooth = {
    enable = lib.mkDefault true;
    powerOnBoot = lib.mkDefault true; # Powers up the controller on boot
    settings = {
      General = {
        Experimental = lib.mkDefault true; # Shows battery charge of connected devices
        ControllerMode = "dual";
      };
    };
  };

  # Install bluetui for managing connections
  environment.systemPackages = with pkgs; [
    bluetui # TUI for managing bluetooth on Linux
  ];
}

