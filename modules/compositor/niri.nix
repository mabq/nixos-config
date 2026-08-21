{
  config,
  pkgs,
  user,
  repoDir,
  ...
}:
{
  imports = [
    ./dependencies/foot.nix
  ];

  # programs.niri.enable = true;

  home-manager.users.${user} =
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          niri # Scrollable-tiling Wayland compositor
          brave # Privacy-oriented browser for Desktop and Laptop computers
          fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
        ];

        file = {
          ".config/niri" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/niri";
            force = true;
          };
        };
      };
    };
}
