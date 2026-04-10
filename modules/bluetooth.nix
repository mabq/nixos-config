{ lib, pkgs, ... }:
{
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    # Important! For headsets to connect, first run `wiremix` and then try to connect.
    bluetui # TUI for managing bluetooth on Linux
  ];
}

