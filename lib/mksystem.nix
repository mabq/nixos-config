{ overlays, nixpkgs, inputs }:

{ machine, user }:

let
  machineConfig = ../machines/${machine}.nix;
  userConfig = ../users/${user}/nixos.nix;
  # homeManagerConfig = ../users/${user}/home-manager.nix;
in nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs machine user; }; # 1
  modules = [
    # { nixpkgs.overlays = overlays; }

    machineConfig
    userConfig
  ];
}

# -----------------------------------------------------------------------------
# 1
#
# Must use `specialArgs`. Special argument values are used in the `imports`
# sections of other modules, using `_module.args` causes infinite recursion.
#
# See https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
# -----------------------------------------------------------------------------
