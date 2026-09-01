{ user, currentThemeDir, ... }:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          libsForQt5.qtstyleplugin-kvantum # Kvantum for qt5 apps
          kdePackages.qtstyleplugin-kvantum # Kvantum for qt6 apps
        ];

        file = {
          ".config/Kvantum/kvantum.kvconfig" = {
            source = mkOutOfStoreSymlink "${currentThemeDir}/kvantum.kvconfig";
            force = true;
          };
        };
      };
    };
}

/*
  QT:
  ===

    UI toolkit developed by KDE plasma.

    Versions currently used: qt5 and qt6.

    Among the apps that use QT are: qBittorrent, OBS, VLC, Dolphin.

  Kvantum:
  ========

    Styling engine on top of QT.

    Makes configuration much simpler. No need to deal with qt5/qt6
    configurations and configuration tools (`qt5ct`/`qt6ct`).

    Includes polished themes by default (check available themes in the GUI
    app). No need to install any additional theme packages.

    QT apps will use the theme specified in:
      `~/.config/Kvantum/kvantum.kvconfig`

    Each of our themes include a Kvantum config file specifying the dark/light
    variant to be used.

    Use the Bash script to change themes. Note that for the application to
    reflect the theme change on the fly a proper configuration of
    xdg-desktop-portal is required (see hypr module).

  Environment variables:
  ======================

    The following env variables are set by the uwsm (see the module):

      QT_STYLE_OVERRIDE="kvantum"
        Instructs QT applications to use Kvantum (instead of qt config files).

      QT_QPA_PLATFORMTHEME="xdgdesktopportal"
        Instructs QT applications to use xdg-desktop-portal for stuff the app
        does not control (e.g. file picker).
*/

/*
  [Qt App]
     │ (Asks for system color scheme)
     ▼
  [xdg-desktop-portal]
     │ (Routes request to the GTK backend)
     ▼
  [xdg-desktop-portal-gtk]
     │ (Queries GSettings for org.gnome.desktop.interface)
     ▼
  [GSETTINGS_BACKEND=keyfile]
     │ (Reads the plain-text file)
     ▼
  ~/.config/glib-2.0/settings/keyfile
*/
