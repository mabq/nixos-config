{ user, repoPath, ... }:
{
  programs.hyprland.withUWSM = true; # See uwsm notes!

  home-manager.users.${user} =
    { config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        file = {
          ".config/uwsm/env" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/uwsm/env";
            force = true;
          };
          ".config/uwsm/env-hyprland" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/uwsm/env-hyprland";
            force = true;
          };
        };
      };
    };
}
