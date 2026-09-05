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

  # Placing all configs/themes in a single directory help a lot for
  # outOfStoreSymliks because those require absolute paths.

  repoConfigDir = "/config";
  repoConfigDirAbs = repoDir + repoConfigDir;

  repoThemeDir = "${repoConfigDir}/${repoName}/themes/${theme}";
  repoThemeDirAbs = repoDir + repoThemeDir;

  # Unfortunately some config files do not allow global varaibles or relative
  # paths, so do a live grep for "__MYNIX_HARDCODED_PATH__" to see where manual
  # changes are required when changing this.
  localThemeDir = "/.config/${repoName}/theme";
  localThemeDirAbs = "/home/${user}" + localThemeDir;

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
      repoConfigDirAbs
      repoThemeDir
      repoThemeDirAbs
      localThemeDir
      localThemeDirAbs
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
