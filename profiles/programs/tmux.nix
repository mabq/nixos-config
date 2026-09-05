{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDirAbs,
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
            source = mkOutOfStoreSymlink "${repoConfigDirAbs}/tmux/${configName}.conf";
            force = true;
          };
          ".local/bin/tmux-sessionizer" = {
            source = mkOutOfStoreSymlink "${repoConfigDirAbs}/tmux/bin/tmux-sessionizer";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations:

    The defaults module includes `~/.local/bin` in PATH which is required for the
    script to work and also sets an environment variable used by the script.

    Shortcuts to trigger the script are set in the shell config files (zsh) and in
    neovim config files.
*/
