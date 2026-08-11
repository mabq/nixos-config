{
  user,
  theme,
  repoDir,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      # This path is hard-coded in configuration files.
      home.file.".config/nixos-config/current/theme" = {
        source = mkOutOfStoreSymlink "${repoDir}/themes/${theme}";
        force = true;
      };
    };
}
