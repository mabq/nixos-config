{
  configName ? "default",
}:
{
  user,
  repoDir,
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
      programs.bat = {
        enable = true;

        # This config never changes, no need for out of store symlink.
        # see `bat --help` for more options
        config = {
          theme = "current";
        };
      };

      home.file = {
        ".config/bat/config" = {
          source = mkOutOfStoreSymlink "${repoDir}/config/bat/${configName}";
          force = true;
        };
        ".config/bat/themes/current.tmTheme" = {
          source = mkOutOfStoreSymlink "${currentThemeDir}/bat.tmTheme";
          force = true;
        };
      };
    };
}
