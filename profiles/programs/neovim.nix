{
  configName ? "default",
}:
{
  self,
  pkgs,
  user,
  repoConfigDir,
  repoConfigDirAbs,
  ...
}:
let
  # Avoid breaking if the module is moved to another directory
  packagesList = self + repoConfigDir + "/nvim/${configName}/packages.nix";
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
        packages = import packagesList { inherit pkgs; };

        file = {
          ".config/nvim" = {
            source = mkOutOfStoreSymlink "${repoConfigDirAbs}/nvim/${configName}";
            force = true;
          };
        };
      };
    };
}
