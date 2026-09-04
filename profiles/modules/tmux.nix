{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDir,
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

          # -- Packages required by scripts --
          fd # Simple, fast and user-friendly alternative to find
          fzf # Command-line fuzzy finder
        ];

        file = {
          ".config/tmux/tmux.conf" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/tmux/${configName}.conf";
            force = true;
          };
          ".local/bin" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/tmux/bin";
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
