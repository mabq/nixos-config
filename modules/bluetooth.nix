{ lib, pkgs, ... }:
{
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    # NOTE:
    # If you cannot connect Sony's Headphones is because the pipewire user services
    # has not initiated. The user session must be initiated for the pipewire's user
    # units to be triggered.
    bluetui # TUI for managing bluetooth on Linux
  ];

}

