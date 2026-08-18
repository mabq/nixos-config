{
  user,
  repoDir,
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
          tmux # Terminal multiplexer
        ];

        file = {
          ".config/tmux/tmux.conf" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/tmux/tmux.conf";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations
  ======================

  - Default module
    Includes the repository's `bin` directory in $PATH.
    Required to execute `tmux-sessionizer` script.

  - Shell config
    Shortcut to invoke `tmux-sessionizer`

  - Neovim config
    Shortcut to invoke `tmux-sessionizer`
*/
