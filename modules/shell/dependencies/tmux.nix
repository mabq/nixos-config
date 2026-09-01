{
  pkgs,
  user,
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
      home = {
        packages = with pkgs; [
          tmux # Terminal multiplexer
          fd # Simple, fast and user-friendly alternative to find (!tmux-sessionizer)
          fzf # Command-line fuzzy finder (!tmux-sessionizer)
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

  - Shell configs
    Include the repository `bin` directory to $PATH (required for
    `tmux-sessionizer` to be reachable.

    The defaults module sets an environment variable used by `tmux-sessionizer`
    to include the repository directory.

    Shortcut to invoke `tmux-sessionizer`

  - Neovim config
    Shortcut to invoke `tmux-sessionizer`
*/
