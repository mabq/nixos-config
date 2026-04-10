{ lib, pkgs, ...}:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wiremix # Simple TUI mixer for PipeWire
  ];

}
