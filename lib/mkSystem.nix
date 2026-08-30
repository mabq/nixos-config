{
  self,
  inputs,
}:
{
  host,
  user,
  profile,
  disk,
  stateVersion,
  theme ? "catppuccin",
}:
let
  repoDir = "/home/${user}/.local/share/nixos-config"; # [1]
  themeDir = "/home/${user}/.config/nixos-config/current/theme"; # [1]

  specialArgs = {
    inherit
      self
      inputs
      host
      user
      profile
      disk
      stateVersion
      theme
      repoDir
      themeDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # [2]
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

  Paths to the local repository and current theme. Used to avoid hard-coding
  these paths into config files in case we ever need to change them.

  Not all config files accept environment variables (these are pushed to env
  variables by the default module), so do a live grep to check where these
  paths are hard-coded before changing them.

  Must be absolute paths cause these are also used to create symlinks.

  [2]

  Must be `specialArgs` — `_module.args` causes infinite recursion when any of
  the these arguments is used in the `imports` section of a module.
  https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
*/
