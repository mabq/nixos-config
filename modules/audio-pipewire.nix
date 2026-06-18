{ lib, pkgs, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
    wiremix # Simple TUI mixer for PipeWire
  ];

  # Required by pipewire
  security.rtkit.enable = mkDefault true;

  services.pipewire = {
    enable = mkDefault true;
    alsa.enable = mkDefault true;
    pulse.enable = mkDefault true;
    # Enable WirePlumber, a modular session / policy manager for PipeWire.
    wireplumber.enable = mkDefault true;
  };
}
