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
          jetbrains-mono # Typeface made for developers
          nerd-fonts.symbols-only # Just the Nerd Font Icons
        ];

        file.".config/fontconfig/fonts.conf" = {
          source = mkOutOfStoreSymlink "${repoPath}/fonts.conf";
          force = true;
        };
      };
    };
}
