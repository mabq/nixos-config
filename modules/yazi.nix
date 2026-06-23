{
  user,
  repoPath,
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

        file = {
          ".config/yazi/yazi.toml" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/yazi.toml";
            force = true;
          };
        };
      };
    };
}
