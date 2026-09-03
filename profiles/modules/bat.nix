{
  pkgs,
  user,
  repoDir,
  currentThemeDir,
  ...
}:
{
  environment.sessionVariables = {

  };

  home-manager.users.${user} =
    { config, ... }:
    # let
    #   mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    # in
    {
      programs.bat = {
        enable = true;
        config.theme = "bat";
        themes.bat = {
          src = "${currentThemeDir}";
          file = "bat.tmTheme";
        };
      };

      # home = {
      #   packages = with pkgs; [
      #     bat # Cat clone with syntax highlighting and Git integration
      #   ];
      #
      #   file = {
      #     ".config/bat/config" = {
      #       source = mkOutOfStoreSymlink "${repoDir}/config/bat/config";
      #       force = true;
      #     };
      #     ".config/bat/themes/current.tmTheme" = {
      #       source = mkOutOfStoreSymlink "${currentThemeDir}/bat.tmTheme";
      #       force = true;
      #     };
      #   };
      # };
    };
}
