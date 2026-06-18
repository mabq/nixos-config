{
  pkgs,
  user,
  repoPath,
  repoUserPath,
  forceFiles,
  ...
}:
{
  programs.zsh.enable = true; # must be enabled to be used as the default shell

  users.users.${user}.shell = pkgs.zsh; # make it the default shell for this user

  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      # TODO: can I access directly under lib?
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          zsh-autosuggestions # Fish shell autosuggestions for Zsh
          zsh-history-substring-search # Fish shell history-substring-search for Zsh
          zsh-syntax-highlighting # Fish shell like syntax highlighting for Zsh
        ];
        file = forceFiles {
          ".zshenv".text = ''
            # Be careful what you put in this file, it affects every zsh invocation (including scp, rsync, etc).
            setopt NO_GLOBAL_RCS # --- Ignore zsh global config files, except `/etc/zshenv` which is read before this file.
            ZDOTDIR="${repoPath}/config/zsh" # --- Source zsh config files directly from the repository. No need to export.
            export REPO_USER_PATH="${repoUserPath}" # --- Hard-coded into some config files.
          '';
          ".zprofile".source = mkOutOfStoreSymlink "${repoPath}/config/zsh/.zprofile";
        };
      };
    };
}
