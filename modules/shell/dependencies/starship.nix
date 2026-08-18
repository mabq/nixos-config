{ user, repoDir, ... }:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
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
            source = mkOutOfStoreSymlink "${repoDir}/config/starship/starship.toml";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations
  ======================

  - Shell init
    Starship must be initialized by a shell config file.
      https://docs.atuin.sh/latest/guide/shell-integration/
      https://docs.atuin.sh/latest/configuration/key-binding/
*/
