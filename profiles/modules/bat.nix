{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoDir,
  currentThemeDir,
  ...
}:
{
  home-manager.users.${user} =
    { config, lib, ... }:
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
            source = mkOutOfStoreSymlink "${repoDir}/config/bat/${configName}";
            force = true;
          };
          ".config/bat/themes/current.tmTheme" = {
            source = mkOutOfStoreSymlink "${currentThemeDir}/bat.tmTheme";
            force = true;
          };
        };

        # This is required to update
        activation.batCache = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          "${pkgs.bat}/bin/bat cache --build
        '';
      };
    };
}
