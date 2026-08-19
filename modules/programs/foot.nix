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
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
        ];

        file = {
          ".config/foot/foot.ini" = {
            # Unfortunately, foot does not allow variables in paths given to
            # `include`, so we must use a user's scoped file.
            source = mkOutOfStoreSymlink "${repoDir}/config/foot.ini";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations
  ======================

  - Default module
    Symlink to current theme.
*/
