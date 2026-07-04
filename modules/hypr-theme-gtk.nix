{ pkgs, user, ... }:
{
  # services.dbus.enable = true;
  # programs.dconf.enable = true;
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = "*";
  # };

  home-manager.users.${user} =
    { config, currentThemePath, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          dconf # Essential: The reliable backend tool for live adjustments
          xdg-desktop-portal-gtk
          # dconf-editor # Optional: GUI for browsing keys

          # Install the actual themes you want to toggle between globally
          gnome-themes-extra # Provides the Adwaita theme
          papirus-icon-theme
        ];

        file = {
          ".config/gtk-3.0/settings.ini" = {
            source = mkOutOfStoreSymlink "${currentThemePath}/gtk-settings.ini";
            force = true;
          };
          ".config/gtk-4.0/settings.ini" = {
            source = mkOutOfStoreSymlink "${currentThemePath}/gtk-settings.ini";
            force = true;
          };
        };
      };
    };
}
