{ inputs, overlays }:
{
  machine,
  user,
  profile,
}:
let
  projectName = "nixos-config"; # 1
  repoPath = "/home/${user}/.local/share/${projectName}"; # 2

  specialArgs = {
    inherit
      machine
      user
      profile
      projectName
      repoPath
      ;
  };

  machineConfig = ../machines/${machine}.nix;
  userConfig = ../users/${user}/${profile}.nix;
  # userHMConfig = ../users/${user}/${profile}.nix; # 3
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # 4
  modules = [
    { nixpkgs.overlays = overlays; }
    inputs.disko.nixosModules.disko
    machineConfig
    userConfig
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
  1. Must be separate from `$repopath`. This variable is used to create paths,
     e.g. `~/.config/<projectName>/current/theme`. If you ever decide to use
     other name change it here, it should update everything automatically.

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
