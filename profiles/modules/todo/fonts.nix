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
          jetbrains-mono # Typeface made for developers
          nerd-fonts.symbols-only # Just the Nerd Font Icons
        ];

        file.".config/fontconfig/fonts.conf" = {
          source = mkOutOfStoreSymlink "${repoConfigDirAbs}/fontconfig/fonts.conf";
          force = true;
        };
      };
    };
}
