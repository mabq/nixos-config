{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # This flake outputs a NixOS configuration
  outputs = { self, nixpkgs, ... }@inputs:
    let
      overlays = [
        # inputs.jujutsu.overlays.default
        # inputs.zig.overlays.default

        (final: prev: rec {
          # Want the latest version of these
          nushell =
            inputs.nixpkgs-unstable.legacyPackages.${prev.system}.nushell;
        })
      ];
      mkSystem = import ./lib/mkSystem.nix { inherit overlays nixpkgs inputs; };
    in {
      nixosConfigurations = {
        macbook = mkSystem "macbook-pro-2010";
        dell = mkSystem "xps-studio-1340";
      };
    };
}
