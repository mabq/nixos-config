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
          ".local/bin/tmux-sessionizer" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/tmux/bin/tmux-sessionizer";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations
  ======================

  - Defaults module
    Includes `~/.local/bin` into PATH.
    Sets an environment variable used in tmux-sessionizer.

  - Shell configs
    Shortcut to invoke `tmux-sessionizer`

  - Neovim config
    Shortcut to invoke `tmux-sessionizer`
*/
