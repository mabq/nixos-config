{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDirAbs,
  localThemeDirAbs,
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
            source = mkOutOfStoreSymlink "${repoConfigDirAbs}/btop/${configName}.conf";
            force = true;
          };
          ".config/btop/themes/current.theme" = {
            source = mkOutOfStoreSymlink "${localThemeDirAbs}/btop.theme";
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
