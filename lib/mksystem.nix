{
  inputs,
  overlays,
}: {
  machine,
  user,
  profile,
}: let
  projectName = "nixos-config"; # 5
  repoPath = "/home/${user}/.local/share/${projectName}"; # 6

  specialArgs = {inherit machine user profile projectName repoPath;};

  machineConfig = ../machines/${machine}/configuration.nix;
  userNixOSConfig = ../users/${user}/nixos.nix;
  userHMConfig = ../users/${user}/${profile}.nix; # 1
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs; # 2
    modules = [
      # { nixpkgs.overlays = overlays; }
      inputs.disko.nixosModules.disko
      machineConfig
      userNixOSConfig
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true; # 3
        home-manager.useUserPackages = true; # 4
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.${user} = userHMConfig;
      }
    ];
  }
#
# 1. https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager#home-manager-vs-nixos
#
# 2. Must use `specialArgs`, `_module.args` causes infinite recursion when any of the passed arguments are used in the `imports` section of other modules.
#    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
#
# 3. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useGlobalPkgs
#
# 4. https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.useUserPackages
#
# 5. Must be separate from `$repopath`. This variable is used to create paths in the system. E.g. `~/.config/<projectName>/current/theme`.
#    If you ever decide to use other name change it here, it should update everything automatically.
#
# 6. This variable is used to create OutOfStore symlinks. Symlinks must point to absolute paths - things like `$HOME` or `~` are not allowed.
#    Change this if you ever decide to place the repository in another location.

