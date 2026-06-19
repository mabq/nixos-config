# If a file isn't tracked by Git, Nix doesn't believe it exists!
{
  description = "My NixOS config";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # 1
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # 2
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      overlays = [ ]; # 3
      mkSystem = import ./lib/mksystem.nix { inherit self inputs overlays; };
    in
    {
      nixosConfigurations = {
        # 4
        nuc = mkSystem {
          machine = "nuc"; # 5
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
  1. Or use `nixos-XX.YY` for stable releases.

  2. Instruct home-manager to use our version of nixpkgs (home-manager is
     designed to expect this).

  3. Only use overlays to correct bugs in packages being used by other packages.
     For upgrading/downgrading specific packages always prefer multiple nixpkgs
     inputs - lighter and no compilation from source required.
     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages

  4. NixOS configuration name - cannot be accessed in NixOS modules.

  5. Machine configuration name - can be accessed in NixOS modules via special
     arguments. Use the same name as the NixOS configuration name - this will be
     set as the default hostname and `nixos-rebuild` command uses the hostname
     when no NixOS configuration name is passed.
*/
