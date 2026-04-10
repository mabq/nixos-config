{ lib, pkgs, ... }:
{
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    bluetui # TUI for managing bluetooth on Linux
  ];
}

