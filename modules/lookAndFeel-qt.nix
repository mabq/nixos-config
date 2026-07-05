{ user, ... }:
{
  home-manager.users.${user} =
    { ... }:
    {
      qt = {
        enable = true;
        platformTheme.name = "gtk"; # Qt apps inherit GTK's dark theme/colors directly
        style.name = "adwaita-dark";
      };
    };
}

# qt5-wayland
# qt6-wayland
#
#
# Qt (Qt5, Qt6)
#   Created by KDE Plasma, but works everywhere.
#   Used by apps like VLC, OBS Studio, qBittorrent, and Dolphin.
#
#   Kvantum is a third-party theme engine that replaces the default way
#   Qt draws its widgets (it only affects applications built on Qt). It
#   does this by using sophisticated SVG graphics and advanced
#   transparency effects to give Qt applications a much more polished,
#   customizable, and modern look than the basic built-in Qt styles can
#   provide. Note that Kvantum requires kvantum themes (normal QT themes
#   are not supported).
#   You have to manually tell your system to use "Kvantum" as the active
#   Qt style.
