{
  user,
  repoPath,
  currentThemePath,
  ...
}:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          btop # Monitor of resources
        ];

        file = {
          ".config/btop/btop.conf" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/btop.conf";
            force = true;
          };
          ".config/btop/themes/current.theme" = {
            source = mkOutOfStoreSymlink "${currentThemePath}/btop.theme";
            force = true;
          };
        };
      };
    };
}
