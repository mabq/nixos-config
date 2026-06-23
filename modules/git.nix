{
  user,
  repoPath,
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

        file = {
          ".config/git/config" = {
            source = mkOutOfStoreSymlink "${repoPath}/users/${user}/config/.gitconfig";
            force = true;
          };
          ".config/lazygit/config.yml" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/lazygit.yml";
            force = true;
          };
        };
      };
    };
}
