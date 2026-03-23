{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # [3]
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # [4]
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    overlays = [];
    mkSystem = import ./lib/mksystem.nix { inherit overlays nixpkgs inputs; };
  in {
    nixosConfigurations = {
      macbook = mkSystem { # [1]
        machine = "macbook-pro-62"; # [2]
        user = "mabq";
      };
    };
  };
}

# [1] The NixOS configuration name. Tightly related to the hostname because
# `nixos-rebuild switch --flake .#<nixos-config>` uses the hostname of the
# current machine as the NixOS configuration name if none is provided.
# If you change it, make sure you also change the hostname in the machine
# configuration file - unfortunatelly the NixOS config name cannot be accessed
# from NixOS modules.
#
# [2] The machine id in this repository. Make it descriptive so that you
# don´t ever need to change it - if you do, you must manually change all the
# hardcoded references.
#
# [3] Or use `nixos-25.11` for more stable releases.
#
# [4] Make the Home-manager flake use our flake version of Nixpkgs. This is
# not something you can do with all flakes, but Home-manager is designed to
# expect this change.

