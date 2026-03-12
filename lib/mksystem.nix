{ overlays, nixpkgs, inputs }:

{ machine, user }:

let
  machineConfig = ../machines/${machine}.nix;
  userConfig = ../users/${user}/nixos.nix;
  # homeManagerConfig = ../users/${user}/home-manager.nix;
in nixpkgs.lib.nixosSystem = {
  modules = [
    # { nixpkgs.overlays = overlays; }

    machineConfig
    userConfig

    # Expose some extra arguments to all modules
    # See https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
    {
      _module.args = { inherit inputs machine user; };
    }
  ];
}
