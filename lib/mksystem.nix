{
  self,
  inputs,
  overlays,
}:
{
  machine,
  user,
  profile,
  theme ? "tokyo-night-moon", # must be one of the themes in the theme directory
}:
let
  repoName = "nixos-config"; # 1
  repoPath = "/home/${user}/.local/share/${repoName}"; # 2
  currentThemePath = "/home/${user}/.config/${repoName}/current/theme"; # 3

  configPath = "${repoPath}/users/${user}/config";

  specialArgs = {
    inherit
      self
      inputs
      machine
      user
      profile
      theme
      repoPath
      currentThemePath
      configPath
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

  2. This is the path where you need to clone the repository.
     The variable is used to create OutOfStore symlinks pointing to the cloned
     repository files.
     Must be an absolute path because symlinks do not expand things like `$HOME`
     or `~`.
     If you ever decide to clone the repository somewhere else, update this
     variable, it should update everything automatically.

  3. A symlink pointing to the selected theme in the repository.
     To change a theme all you need to do is change this symlink.

  4. https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager#home-manager-vs-nixos

  5. Must use `specialArgs`, `_module.args` causes infinite recursion when any of
     the passed arguments is used in the `imports` section of other modules.
     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules

  6. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useGlobalPkgs

  7. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
*/
