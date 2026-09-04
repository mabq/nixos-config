{
  pkgs,
  user,
  repoConfigDir,
  currentThemeDir,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          btop # Monitor of resources
        ];

        file = {
          ".config/btop/btop.conf" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/btop/btop.conf";
            force = true;
          };
          ".config/btop/themes/current.theme" = {
            source = mkOutOfStoreSymlink "${currentThemeDir}/btop.theme";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations
  ======================

  - Default module
    Symlink to current theme.
*/
