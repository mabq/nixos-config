{
  self,
  inputs,
}:
{
  user,
  profile,
  theme ? "catppuccin",
}:
let
  repoDir = "/home/${user}/.local/share/nixos-config"; # [1]
  themeDir = "/home/${user}/.config/nixos-config/theme"; # [1]

  specialArgs = {
    inherit
      self
      inputs
      user
      profile
      theme
      repoDir
      themeDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # [2]
  modules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    # { home-manager.extraSpecialArgs = specialArgs; }
    # inputs.sops-nix.nixosModules.sops

    ../profiles/${profile}.nix
  ];
}

/*
  [1]

  Paths to the local repository and current theme. Used to avoid hard-coding
  paths in config. Not all config files accept environment variables though, so
  do a live grep to check where these paths are hard-coded before changing
  them.

  Must be absolute because these are also used to create symlinks.

  [2]

  Must be `specialArgs` — `_module.args` causes infinite recursion when any of
  the these arguments is used in the `imports` section of a module.
  https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
*/
