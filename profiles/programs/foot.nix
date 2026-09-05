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
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
        ];

        file = {
          ".config/foot/foot.ini" = {
            # This config file requires a hard-coded path to the theme. The
            # alternative was to use home-manager options to configure foot but
            # that would make it harder to have different config files in case
            # we need them.
            source = mkOutOfStoreSymlink "${repoConfigDir}/foot/${configName}.ini";
            force = true;
          };
        };
      };
    };
}

/*
  Related configurations:

    The defaults module creates the symlink for the local theme used in the
    config file.
*/
