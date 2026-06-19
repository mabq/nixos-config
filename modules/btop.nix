{
  user,
  repoPath,
  currentThemePath,
  forceFiles,
  ...
}:
{
  # ----------------------------------------------------------------------------

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

        file = forceFiles {
          ".config/btop/btop.conf".source = mkOutOfStoreSymlink "${repoPath}/config/btop/btop.conf";
          ".config/btop/themes/current.theme".source = mkOutOfStoreSymlink "${currentThemePath}/btop.theme";
        };
      };
    };
}
