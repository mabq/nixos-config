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
          git # Distributed version control system
          gh # CLI GitHub tool (authenticate from the terminal)
          lazygit # Simple terminal UI for git commands
          delta # Syntax-highlighting pager for git
        ];

        file = {
          ".config/git/config" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/git/${configName}";
            force = true;
          };
          ".config/lazygit/config.yml" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/lazygit/config.yml";
            force = true;
          };
        };
      };
    };
}
