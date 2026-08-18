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
  currentThemeDir = "/home/${user}/.config/nixos-config/current/theme"; # [2]

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
      currentThemeDir
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

  This variable helps avoid hard-coding the same path in many modules but not
  in some configuration files, if you ever need to change this make sure you
  check with grep and update all those files as well.

  [3]

  Must be `specialArgs` — `_module.args` causes infinite recursion when any of
  the these arguments is used in the `imports` section of a module.
  https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
*/
