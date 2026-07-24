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
      inputs.nixpkgs.follows = "nixpkgs"; # [3]
    };
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
          machine = "XPS-1340";
          user = "mabq";
          profile = "plex-server";
          stateVersion = "26.05";
        };
      };
    };
}

/*
  [1]

  The main nixpkgs branch to be used by this flake.

  `nixos-unstable` advances after NixOS tests pass. More stable for NixOS
  systems.

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

  Force the input flake to use the nixpkgs branch used by this flake.

  This is recommended for most flake inputs, but that is now always the case.
  Ask AI whether you should do this for any new input flakes you add.

  [4]

  Our nixos configuration names. You pass one of these to:

    `sudo nixos-rebuild --flake .#<NIXOS-CONFIGURATION-NAME>`

  If no nixos configuration name is passed, nix will try to match one with the
  value of the current `hostname`.

  Unfortunately, it is not possible to grab the key value on the RHS of the
  expression, so we need to type the same value on both sides.

  [5]

  Must match a filename in `/hardware`.

  Do not reuse hardware files!, read ./notes/hardware-files.md
*/
