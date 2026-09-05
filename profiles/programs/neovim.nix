{
  configName ? "default",
}:
{
  self,
  lib,
  pkgs,
  user,
  repoDir,
  repoConfigDir,
  ...
}:
let
  # Avoid breaking this module if moves
  configDir = self + lib.strings.removePrefix "${repoDir}" repoConfigDir;
in
{
  # Make nvim the default text editor.
  # Read session variables notes in the default module for more information
  # about this option..
  environment.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home-manager.users.${user} =
    { config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = import "${configDir}/nvim/${configName}/packages.nix" { inherit pkgs; };

        file = {
          ".config/nvim" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/nvim/${configName}";
            force = true;
          };
        };
      };
    };
}
