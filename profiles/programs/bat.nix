{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDirAbs,
  repoThemeDirAbs,
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
          bat # Cat clone with syntax highlighting and Git integration
        ];

        file = {
          ".config/bat/config" = {
            source = mkOutOfStoreSymlink "${repoConfigDirAbs}/bat/${configName}";
            force = true;
          };
          ".config/bat/themes/current.tmTheme" = {
            # Not to the local theme dir (it does not change), we need to
            # trigger the change.
            source = mkOutOfStoreSymlink "${repoThemeDirAbs}/bat.tmTheme";
            force = true;
            # Bat requires a cache rebuild for a new theme to apply. This
            # activation script only runs when the theme actually changes.
            # The bat home-manager module runs it on every build.
            onChange = ''
              ${pkgs.bat}/bin/bat cache --build
            '';
          };
        };
      };
    };
}
