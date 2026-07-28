{
  self,
  inputs,
}:
{
  host,
  user,
  profile,
  stateVersion,
  theme ? "catppuccin", # Must be one in `/themes`
}:
let
  repoDir = "/home/${user}/.local/share/nixos-config"; # `mkOutOfStoreSymlink` requires absolute paths

  specialArgs = {
    inherit
      self
      inputs
      host
      user
      profile
      stateVersion
      theme
      repoDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # 3
  modules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    # { home-manager.extraSpecialArgs = specialArgs; }
    ../modules/defaults.nix
    ../hosts/${host}.nix
    ../users/${user}
    ../profiles/${profile}.nix
  ];
}

/*
  1. If you ever decide to change the name of the repository, update this
     variable, everything should work.

  2. This is the path where you need to clone the repository.
     The variable is used to create OutOfStore symlinks pointing to the cloned
     repository files.
     Must be an absolute path because symlinks do not expand things like `$HOME`
     or `~`.
     If you ever decide to clone the repository somewhere else, update this
     variable, it should update everything automatically.

  3. Must use `specialArgs`, `_module.args` causes infinite recursion when any of
     the passed arguments is used in the `imports` section of other modules.
     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
*/
