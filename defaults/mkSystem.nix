{
  self,
  inputs,
}:
{
  host,
  user,
  profile,
  theme ? "catppuccin",
  repoBranch ? "main",
}:
let
  # These variables are used across nix and program's configuration files to
  # avoid hard-coding the paths, making it a lot easier to move directories or
  # change the project name if ever required. These must be absolute paths
  # because they are mainly used to create symlinks.
  #
  # Unfortunately these can't be used everywhere, so before changing them do a
  # quick live-grep to see if you need to do some manual change.
  repoName = "mynix";
  repoDir = "/home/${user}/.local/share/${repoName}"; # [1]
  repoConfigDir = "${repoDir}/config";
  repoThemeDir = "${repoDir}/themes/${theme}";

  currentThemeDir = "/home/${user}/.config/${repoName}/theme"; # [1]

  # Passing these as `specialArgs` (instead of `_module.args`) allows me to use
  # these variables in the `imports` sections of all modules without causing
  # infinite recursion. For more info see:
  # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  specialArgs = {
    inherit
      self
      inputs
      host
      user
      profile
      theme
      repoBranch
      repoName
      repoDir
      repoConfigDir
      repoThemeDir
      currentThemeDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs; # [2]
  modules = [
    # Import all flake inputs modules here. Nix uses lazy-loading so it won't
    # actually load a module that is not required by the actual configuration.
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    # inputs.sops-nix.nixosModules.sops

    # Import the configuration modules here.
    ./defaults.nix
    ../hosts/${host}.nix
    ../users/${user}.nix
    ../profiles/${profile}.nix
  ];
}
