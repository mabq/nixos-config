{ lib, pkgs, ... }:
with lib;
{
  services.pipewire = {
    enable = mkDefault true;
    alsa.enable = mkDefault true;
    pulse.enable = mkDefault true;
    # Enable WirePlumber, a modular session / policy manager for PipeWire.
    wireplumber.enable = mkDefault true;
  };

  security.rtkit.enable = mkDefault true; # required by pipewire

  environment.systemPackages = with pkgs; [
    wiremix # Simple TUI mixer for PipeWire
  ];
}
