{
  pkgs,
  user,
  repoPath,
  currentThemePath,
  ...
}:
{
  # Must be enabled to be used as the default shell
  programs.zsh.enable = true;

  # User default shell
  users.users.${user}.shell = pkgs.zsh;

  # Home-manager
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          atuin # Replacement for a shell history
          bat # Cat clone with syntax highlighting and Git integration
          exfatprogs # exFAT filesystem userspace utilities
          eza # Modern, maintained replacement for ls
          fd # Simple, fast and user-friendly alternative to find
          ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
          fzf # Command-line fuzzy finder
          imagemagick # Software suite to create, edit, compose, or convert bitmap images
          parted # Create, destroy, resize, check, and copy partitions
          ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
          zoxide # Fast cd command that learns your habits
          zsh-autosuggestions # Fish shell autosuggestions for Zsh
          zsh-history-substring-search # Fish shell history-substring-search for Zsh
          zsh-syntax-highlighting # Fish shell like syntax highlighting for Zsh
        ];

        file = {
          ".zshenv" = {
            text = ''
              # Be careful what you put in this file, it affects every zsh invocation (including scp, rsync, etc).
              setopt NO_GLOBAL_RCS # --- Ignore zsh global config files, except `/etc/zshenv` which is read before this file.
              ZDOTDIR="${repoPath}/config/zsh" # --- Source zsh config files directly from the repository. No need to export.
              export NC_REPO_PATH="${repoPath}" # --- Used to include binaries of this repo to PATH
              export NC_CURRENT_THEME_PATH="${currentThemePath}" # --- Used to point config files to current theme
            '';
            force = true;
          };

          ".zprofile" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/zsh/.zprofile";
            force = true;
          };
        };
      };
    };
}
