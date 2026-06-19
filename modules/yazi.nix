{
  user,
  repoPath,
  forceFiles,
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
          yazi # Blazing fast terminal file manager written in Rust, based on async I/O
        ];

        file = forceFiles {
          ".config/yazi/yazi.toml".source = mkOutOfStoreSymlink "${repoPath}/config/yazi/yazi.toml";
        };
      };
    };
}
