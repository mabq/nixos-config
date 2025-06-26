{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      mkSystem = import ./lib/mkSystem.nix {
        inherit nixpkgs nixpkgs-unstable home-manager inputs;
      };
    in {
      nixosConfigurations = {
        macbook = mkSystem "macbook-pro-2010";
        dell = mkSystem "xps-studio-1340";
      };
    };
}
