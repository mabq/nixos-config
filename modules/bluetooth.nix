{ lib, user, ... }:
with lib;
{
  hardware.bluetooth = {
    enable = mkDefault true;
    powerOnBoot = mkDefault true; # ensure Bluetooth is powered on after reboot
    settings = {
      General = {
        Experimental = mkDefault true; # required for some newer codecs like LDAC
        FastConnectable = mkDefault true; # for faster connections (may increase power usage)
      };
      Policy = {
        AutoEnable = mkDefault true; # automatically enable all controllers when found
      };
    };
  };

  home-manager.users.${user} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bluetui # TUI for managing bluetooth on Linux [4]
      ];
    };
}
