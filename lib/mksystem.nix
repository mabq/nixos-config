{ overlays, nixpkgs, inputs }:

{ machine, user }:

let
  machineConfig = ../machines/${machine}.nix;
  userConfig = ../users/${user}/nixos.nix;
  # homeManagerConfig = ../users/${user}/home-manager.nix;
in nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs machine user; };
  modules = [
    # { nixpkgs.overlays = overlays; }

    machineConfig
    userConfig
  ];
}
