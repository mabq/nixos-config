{
  configName,
}:
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
          starship # Customizable prompt for any shell
        ];

        file = {
          ".config/starship.toml" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/starship/${configName}.toml";
            force = true;
          };
        };
      };
    };
}

# Starship must be initialized by a shell config file
