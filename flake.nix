{
  description = "My NixOS config";

  inputs = {
    nixpkgs = {
      # url = "github:NixOS/nixpkgs/nixos-25.11";
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    overlays = [];
    mkSystem = import ./lib/mksystem.nix { inherit overlays nixpkgs inputs; };
  in {
    nixosConfigurations.macbook-pro-62 = mkSystem {
      machine = "macbook-pro-62";
      user = "mabq";
    };
  };
}
