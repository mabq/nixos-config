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
    nixosConfigurations.macbook-pro-62 = mkSystem { # 1
      machine = "macbook-pro-62"; # 2
      user = "mabq";
    };
  };
}

# -----------------------------------------------------------------------------
# 1
#
# This name is used to target a NixOS configuration when using
# `nixos-rebuild switch --flake .#<name>`
# -----------------------------------------------------------------------------
# 2
#
# The name of the NixOS configuration can't be accesse from within Nix modules,
# so we use the `machine` attribute to target the machine files.
#
# This name is used by default as the hostname, but you can overwrite that
# in the machine-specific file.
# -----------------------------------------------------------------------------
