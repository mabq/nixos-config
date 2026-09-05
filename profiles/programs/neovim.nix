{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDir,
  ...
}:
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
        packages = import "${repoConfigDir}/nvim/packages.nix";

        file = {
          ".config/nvim" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/nvim/${configName}";
            force = true;
          };
        };
      };
    };
}
