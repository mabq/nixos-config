{
  self,
  inputs,
}:
{
  user,
  profile,
  theme ? "catppuccin",
  branch ? "main",
}:
let
  repoName = "mynix";
  repoDir = "/home/${user}/.local/share/${repoName}"; # [1]
  currentThemeDir = "/home/${user}/.config/${repoName}/theme"; # [1]

  specialArgs = {
    inherit
      self
      inputs
      user
      profile
      theme
      branch
      repoName
      repoDir
      currentThemeDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # [2]
  modules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
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
