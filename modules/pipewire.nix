{ lib, ...}:
{
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true; # [1]
    jack.enable = lib.mkDefault true;  # [2]
    wireplumber.enable = lib.mkDefault true;  # [3]
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };
  };
}

# ---

# [1] PulseAudio Replacement (Drop-in Compatible). Applications using
# PulseAudio APIs work unchanged.
#
# [2] WirePlumber handles Auto-connecting microphones/headsets, Bluetooth
# profile switching (HSP/HFP/A2DP), Audio routing rules, Device priority, etc.
#
# [3] JACK Replacement (Pro Audio). Low-latency audio for digital audio
# workstations.
