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
