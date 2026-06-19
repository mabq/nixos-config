{
  user,
  repoPath,
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
          starship # Customizable prompt for any shell
        ];

        file = forceFiles {
          ".config/starship.toml".source = mkOutOfStoreSymlink "${repoPath}/config/starship/starship.toml";
        };
      };
    };
}
