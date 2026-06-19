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
          tmux # Terminal multiplexer
        ];

        file = forceFiles {
          ".config/tmux/tmux.conf".source = mkOutOfStoreSymlink "${repoPath}/tmux/tmux.conf";
        };
      };
    };
}
