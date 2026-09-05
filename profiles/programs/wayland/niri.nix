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
  # TODO: Find out why this works and just installing the packages does not
  programs.niri.enable = true;

  home-manager.users.${user} =
    { config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          # -- Make sure you install every package required by the configs --
          fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
          brave # Privacy-oriented browser for Desktop and Laptop computers
          nautilus # File manager for GNOME
        ];

        file = {
          ".config/niri" = {
            source = mkOutOfStoreSymlink "${repoConfigDir}/niri/${configName}";
            force = true;
          };
        };
      };
    };
}
