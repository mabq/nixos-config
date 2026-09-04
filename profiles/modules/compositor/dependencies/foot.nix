{
  pkgs,
  user,
  repoConfigDir,
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
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
        ];

        file = {
          ".config/foot/foot.ini" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/foot/foot.ini";
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
