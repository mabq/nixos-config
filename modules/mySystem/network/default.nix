{ config, lib, machine, ... }:
with lib;
{
  imports = [
    ./networkd.nix
    ./networkmanager.nix
  ];

  options.mySystem.network.manager = mkOption {
    type = types.enum [ "networkd" "networkmanager" ];
    default = "networkd";
    description = "Pick a network manager ('networkd' or 'networkmanager').";
  };

  config = mkMerge [
    # Global networking settings go here
    {
      networking = {
        hostName = mkDefault machine;
        firewall.enable = mkDefault true;
      };
    }

    # Use the desired network manager
    (mkIf (config.mySystem.network.manager == "networkd") {
      mySystem.network.networkd.enable = true;
    })

    (mkIf (config.mySystem.network.manager == "networkmanager") {
      mySystem.network.networkmanager.enable = true;
    })
  ];
}
