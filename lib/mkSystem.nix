{
  self,
  inputs,
}:
{
  host,
  user, # without this here we cannot pass the repo absolute path to every modle
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
      theme
      repoDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # 4
  modules = [
    inputs.home-manager.nixosModules.home-manager

    # -- Common configs
    ../modules/defaults.nix
    {
      system.stateVersion = stateVersion;
      users.users.${user} = {
        isNormalUser = true;
        home = "/home/${user}";
      };

      home-manager = {
        useGlobalPkgs = true; # 5
        useUserPackages = true; # 6
        extraSpecialArgs = specialArgs;
        users.${user}.home = {
          username = user;
          homeDirectory = "/home/${user}";
          stateVersion = stateVersion;
        };
      };
    }

    # -- Custom configs
    ../hosts/${host}.nix
    ../users/${user}
    ../profiles/${profile}.nix # things that require human decision-making
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
