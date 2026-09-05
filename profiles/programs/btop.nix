{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDir,
  localThemeDir,
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
            source = mkOutOfStoreSymlink "${repoConfigDir}/btop/${configName}.conf";
            force = true;
          };
          ".config/btop/themes/current.theme" = {
            source = mkOutOfStoreSymlink "${localThemeDir}/btop.theme";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations:
    The defaults module creates local theme dir symlink.
*/
