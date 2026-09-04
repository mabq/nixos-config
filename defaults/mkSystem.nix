{
  self,
  inputs,
}:
{
  host,
  user,
  profile,
  theme ? "tokyo-night",
  repoBranch ? "main",
}:
let
  # These variables are used across nix and configuration files to avoid
  # hard-coding those paths. Makes changing things much easier later.
  repoName = "mynix";
  repoUrl = "https://github.com/mabq/${repoName}.git";
  repoDir = "/home/${user}/.local/share/${repoName}";
  repoConfigDir = "${repoDir}/config";
  repoThemeDir = "${repoDir}/themes/${theme}";
  localThemeDir = "/home/${user}/.config/${repoName}/theme";

  # `specialArgs` (unlike `_module.args`) does not cause infinite recursion
  # when using one of these in the `imports` section of another module.
  #  https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
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
      repoUrl
      repoDir
      repoConfigDir
      repoThemeDir
      localThemeDir
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;
  modules = [
    # Modules provided by the flake. Nix uses lazy-loading so it only loads
    # what is actually required.
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    # inputs.sops-nix.nixosModules.sops

    # Config files
    ./defaults.nix
    ../hosts/${host}.nix
    ../users/${user}.nix
    ../profiles/${profile}.nix
  ];
}
