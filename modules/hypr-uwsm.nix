{ user, repoPath, ... }:
{
  # See `uwsm` in the notes directory.
  programs.hyprland.withUWSM = true;

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
          # ".config/uwsm/env.d/hm-session-vars" = {
          #   source = mkOutOfStoreSymlink "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
          #   force = true;
          # };
        };
      };
    };
}
