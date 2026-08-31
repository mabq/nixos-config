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
          git # Distributed version control system
          gh # CLI GitHub tool (authenticate from the terminal)
          lazygit # Simple terminal UI for git commands
          delta # Syntax-highlighting pager for git
        ];

        file = {
          ".config/git/config" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/git/${user}";
            force = true;
          };
          ".config/lazygit/config.yml" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/lazygit/lazygit.yml";
            force = true;
          };
        };
      };
    };
}
