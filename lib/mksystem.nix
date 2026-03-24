{ overlays, nixpkgs, inputs }:

{ machine, user }:

let
  machineConfig = ../machines/${machine}/configuration.nix;
  userNixOSConfig = ../users/${user}/nixos.nix;
  # homeManagerConfig = ../users/${user}/home-manager.nix;
in nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs machine user; }; # 1
  modules = [
    # { nixpkgs.overlays = overlays; }
    machineConfig
    userNixOSConfig
  ];
}

# [1] Must use `specialArgs`, `_module.args` causes infinite recursion when
# any of the passed arguments are used in the `imports` section of other modules.
# See https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
