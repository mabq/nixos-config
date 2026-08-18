{
  user,
  repoDir,
  themeDir,
  ...
}:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          bat # Cat clone with syntax highlighting and Git integration
        ];

        file = {
          ".config/bat/config" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/bat/config";
            force = true;
          };
          ".config/bat/themes/current.tmTheme" = {
            source = mkOutOfStoreSymlink "${themeDir}/bat.tmTheme";
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
