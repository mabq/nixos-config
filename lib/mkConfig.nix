{
  self,
  inputs,
}:
nixos-configuration:
{
  hardware,
  user,
  theme ? "catppuccin", # Must be one in `/themes`
  shell ? "zsh",
  compositor ? "hyprland",
}:
let
  # `mkOutOfStoreSymlink` requires absolute paths
  repoDir = "/home/${user}/.local/share/nixos-config";

  specialArgs = {
    inherit
      self
      inputs
      hardware
      user
      theme
      shell
      compositor
      repoDir
      ;
  };

  # pure hardware configurations for the given machine (CPU, GPU, etc.)
  hardwareConfig = ../hardware/${hardware}.nix;

  # selected system configuration
  nixosConfig = ../nixos-configurations/${nixos-configuration}.nix;

  # Dotfiles, user-specific packages, and desktop environment settings.
  userConfig = ../users/${user}/${hardware}.nix;

  # TODO: Remove later
  userHMConfig = ../users/${user}/home.nix; # 3
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # 4
  modules = [
    hardwareConfig
    nixosConfig
    # inputs.disko.nixosModules.disko
    ../modules
    userConfig
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true; # 5
      home-manager.useUserPackages = true; # 6
      # TODO: Should not be required since every single module is a NixOS module
      home-manager.extraSpecialArgs = specialArgs;
      # TODO: Remove later
      home-manager.users.${user} = userHMConfig;
    }
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

  3. A symlink pointing to the selected theme in the repository.
     To change a theme all you need to do is change this symlink.

  4. https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager#home-manager-vs-nixos

  5. Must use `specialArgs`, `_module.args` causes infinite recursion when any of
     the passed arguments is used in the `imports` section of other modules.
     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules

  6. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useGlobalPkgs

  7. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
*/
