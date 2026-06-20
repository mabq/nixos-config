{
  user,
  repoPath,
  forceFiles,
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
          delta # Syntax-highlighting pager for git
          gh # GitHub CLI tool
          git # Distributed version control system
          lazygit # Simple terminal UI for git commands
        ];

        file = forceFiles {
          ".config/git/config".source = mkOutOfStoreSymlink "${repoPath}/users/${user}/config/.gitconfig";
          ".config/lazygit/config.yml".source = mkOutOfStoreSymlink "${repoPath}/config/lazygit/lazygit.yml";
        };
      };
    };
}
