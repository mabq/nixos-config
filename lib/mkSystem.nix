{
  self,
  inputs,
}:
{
  host,
  user,
  profile,
  stateVersion,
  theme ? "catppuccin",
}:
let
  repoDir = "/home/${user}/.local/share/nixos-config"; # [1]
  themeDirHome = ".config/nixos-config/current/theme"; # [2]
  themeDir = "/home/${user}/${themeDirHome}"; # [2]

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
      themeDirHome
      themeDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # [3]
  modules = [
    # { home-manager.extraSpecialArgs = specialArgs; }
    ../modules/default.nix
    ../hosts/${host}.nix
    ../users/${user}
    ../profiles/${profile}.nix
  ];
}

/*
  [1]

  This is the path where you need to clone the flake repository.

  Symlinks require absolute paths. Used by `mkOutOfStoreSymlink` accross many
  modules.

  [2]

  Path of the current theme (symlink to repository).

  These variables are an attempt to reduce the places where the path
  hard-coded, unfortunatelly not all configuration files accept global
  variables. So, if you ever need to change this, make sure you do a grep and
  update those files as well.

  [3]

  Must be `specialArgs` — `_module.args` causes infinite recursion when any of
  the these arguments is used in the `imports` section of a module.
  https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
*/
