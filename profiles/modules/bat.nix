{
  configName,
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
      # By enabling the program, instead of just adding the pkgs, home-manager
      # runs an activation script that rebuilds the bat cache, which is
      # required for a new theme to actually apply.
      #  https://github.com/sharkdp/bat#adding-new-themes
      #  https://github.com/nix-community/home-manager/blob/d9d750e4fc11c10cab2da677bdd31e427f3a3a71/modules/programs/bat.nix#L210
      programs.bat.enable = true;

      home = {
        file = {
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
    };
}
