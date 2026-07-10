{
  config,
  lib,
  user,
  repoPath,
  currentThemePath,
  ...
}:
let
  selectedTheme = config.my.theme;
in
{
  config = lib.mkIf config.my.desktop.enable {
    home-manager.users.${user} =
      { config, lib, ... }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
        # `currentThemePath` is an absolute path (mainly used for symlinks and they required an absolute path).
        # `home.file` here expects a relative path from `/home/{user}`, so we need to remove that part.
        themesDir = lib.removePrefix "/home/${user}" currentThemePath;
      in
      {
        home.file."${themesDir}" = {
          source = mkOutOfStoreSymlink "${repoPath}/themes/${selectedTheme}";
          force = true;
        };
      };
  };
}

/*
  With this approach we can try out new themes on the fly, no need to rebuild
  for most apps.

  Is just a pointer to a theme in the repo, no unnecesary files are added.
*/
