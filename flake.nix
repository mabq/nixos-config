# If a file isn't tracked by Git, it does not exist for Nix!
{
  description = "My nixos configs";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # or `nixos-XX.YY` for stable releases
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # 1
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      overlays = [ ]; # 2
      mkSystem = import ./lib/mksystem.nix { inherit self inputs overlays; };
    in
    {
      nixosConfigurations = {
        # 3
        nuc = mkSystem {
          machine = "nuc"; # 4
          user = "mabq";
          profile = "desktop";
        };
        macbook = mkSystem {
          machine = "macbook";
          user = "mabq";
          profile = "desktop";
        };
        xps = mkSystem {
          machine = "xps";
          user = "mabq";
          profile = "plex";
        };
      };
    };
}

/*
  1. Instruct home-manager to use our version of nixpkgs (home-manager is
     designed to expect this).

  2. Only use overlays to correct bugs in packages being used by other packages.
     For upgrading/downgrading specific packages always prefer multiple nixpkgs
     inputs - lighter and no compilation from source required.
     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages

  3. NixOS configuration name - cannot be accessed in NixOS modules.

  4. Machine configuration name - can be accessed in NixOS modules via special
     arguments. Use the same name as the NixOS configuration name - this will be
     set as the default hostname and `nixos-rebuild` command uses the hostname
     when no NixOS configuration name is passed.
*/
