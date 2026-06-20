{
  self,
  inputs,
  overlays,
}:
{
  machine,
  user,
  profile,
}:
let
  repoName = "nixos-config"; # 1
  repoPath = "/home/${user}/.local/share/${repoName}"; # 2

  configPath = "${repoPath}/users/${user}/config";

  theme = "tokyo-night"; # must match one of the directory names in the themes folder
  currentThemePath = "/home/${user}/.config/${repoName}/current/theme";

  # Helper functions
  forceFiles = fileSet: inputs.nixpkgs.lib.mapAttrs (name: value: value // { force = true; }) fileSet;

  specialArgs = {
    inherit
      self
      inputs
      machine
      user
      profile
      repoName
      repoPath
      configPath
      theme
      currentThemePath
      forceFiles
      ;
  };

  machineConfig = ../machines/${machine}.nix;
  userProfile = ../users/${user}/${profile}.nix;
  # TODO: Rewrite everything in home to nixos modules
  userHMConfig = ../users/${user}/home.nix; # 3
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # 4
  modules = [
    inputs.disko.nixosModules.disko
    { nixpkgs.overlays = overlays; }
    machineConfig
    userProfile
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true; # 5
      home-manager.useUserPackages = true; # 6
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users.${user} = userHMConfig;
    }
  ];
}

/*
  1. If you ever decide to change the name of the repository, update this
     variable, it should update everything automatically.

  2. This variable is used to create OutOfStore symlinks. Symlinks must point to
     absolute paths - things like `$HOME` or `~` are not allowed. Change this if
     you ever decide to place the repository in another location.

  3. https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager#home-manager-vs-nixos

  4. Must use `specialArgs`, `_module.args` causes infinite recursion when any of
     the passed arguments is used in the `imports` section of other modules.
     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules

  5. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useGlobalPkgs

  6. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
*/
