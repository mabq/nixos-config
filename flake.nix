{
  description = "My nixos configs";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable"; # [1]
    };

    home-manager = {
      url = "github:nix-community/home-manager/master"; # [2]
      inputs.nixpkgs.follows = "nixpkgs"; # [3]
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self, ... }@inputs:
    let
      mkSystem = import ./lib/mkSystem.nix { inherit self inputs; };
    in
    {
      nixosConfigurations = {
        # [4]
        "xps" = mkSystem {
          user = "mabq";
          profile = "plex-server";
          branch = "restructure";
        };
      };
    };
}

/*
  [1]

  The main nixpkgs branch to be used by this flake.

  `nixos-unstable` advances after NixOS integration tests pass — recommended
  when using NixOS. If you want an even more stable branch use the last version
  available.

  `nixpkgs-unstable` advances after package builds succeed (no full NixOS
  integration tests).

  Both lag behind `master` for a couple of days. Check status at
  https://status.nixos.org.

  [2]

  The home-manager branch to be used by this flake.

  We explicitly use the `master` branch since that is the home-manager branch
  that is tested against the "unstable" branches of nixpkgs.

  If you ever change the `nixpkgs` branch to some fixed version like `26.06`
  you should also change the home-manager branch to match that one.

  [3]

  Force the input flake to use the same nixpkgs branch used by this flake.

  This is recommended for most input flakes, but that is now always the case.
  Ask AI whether you should do this for any new input flakes you add.

  [4]

  The nixosConfiguration name is only used by the cli command targeting the
  configuration, for example:

    `sudo nixos-rebuild --flake .#<CONFIGURATION-NAME>`

  The attributes, on the other hand, are used to target configuration files.
*/
