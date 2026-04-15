# Set the network manager on per-machine basis using `mySystem.network.manager = "networkd|networkmanager";`

{ config, lib, ... }:
with lib;
{
  imports = [
    ./networkd.nix
    ./networkmanager.nix
  ];

  # Default settings
  options.mySystem.network.manager = mkOption {
    type = types.enum [ "networkd" "networkmanager" ];
    description = "Machine network manager.";
  };

  config = mkMerge [
    (mkIf (config.mySystem.network.manager == "networkd") {
      mySystem.network.networkd.enable = true;
    })

    (mkIf (config.mySystem.network.manager == "networkmanager") {
      mySystem.network.networkmanager.enable = true;
    })
  ];
}
