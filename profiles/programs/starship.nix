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
          starship # Customizable prompt for any shell
        ];

        file = {
          ".config/starship.toml" = {
            source = mkOutOfStoreSymlink "${repoConfigDirAbs}/starship/${configName}.toml";
            force = true;
          };
        };
      };
    };
}

# Important!
#  Starship must be initialized by a shell config file.
