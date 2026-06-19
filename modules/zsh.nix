{
  pkgs,
  user,
  repoPath,
  forceFiles,
  ...
}:
{
  # Must be enabled to be used as the default shell
  programs.zsh.enable = true;

  # User default shell
  users.users.${user}.shell = pkgs.zsh;

  # ----------------------------------------------------------------------------

  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          # These packages are used in zsh config files
          atuin # Replacement for a shell history
          bat # Cat clone with syntax highlighting and Git integration
          exfatprogs # exFAT filesystem userspace utilities
          eza # Modern, maintained replacement for ls
          fd # Simple, fast and user-friendly alternative to find (!neovim)
          ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
          fzf # Command-line fuzzy finder (!yazi)
          imagemagick # Software suite to create, edit, compose, or convert bitmap images (!elephant)
          parted # Create, destroy, resize, check, and copy partitions
          ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep (!neovim)
          zoxide # Fast cd command that learns your habits
          zsh-autosuggestions # Fish shell autosuggestions for Zsh
          zsh-history-substring-search # Fish shell history-substring-search for Zsh
          zsh-syntax-highlighting # Fish shell like syntax highlighting for Zsh
        ];

        file = forceFiles {
          ".zshenv".text = ''
            # Be careful what you put in this file, it affects every zsh invocation (including scp, rsync, etc).
            setopt NO_GLOBAL_RCS # --- Ignore zsh global config files, except `/etc/zshenv` which is read before this file.
            ZDOTDIR="${repoPath}/config/zsh" # --- Source zsh config files directly from the repository. No need to export.
            export REPO_PATH="${repoPath}" # --- Hard-coded into some config files.
          '';
          ".zprofile".source = mkOutOfStoreSymlink "${repoPath}/config/zsh/.zprofile";
        };
      };
    };
}
