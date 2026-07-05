{ pkgs, user, ... }:
{
  home-manager.users.${user} =
    { ... }:
    {
      home.packages = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qtstyleplugin-kvantum
      ];
    };
}

/*
  QT is the UI toolkit developed by KDE Plasma.

  There are two versions still used by many apps:
    qt5 (e.g. vlc)
    qt6 (e.g. qbittorrent)

  Explanation:

    When using KDE plasma you can manage the look of QT apps through the system
    settings. When using a minimal wayland compositor like Hyprland you need
    tools to manage QT settings.

    > Do not use `qt5ct` and `qt6ct`. Those are just GUI tools that end up
      editing files in your home directory. I tried to configure QT using
      those and never liked the results.

    Kvantum is a theme engine that changes how QT applications look. It
    includes several good themes by default. I use `KvGnome` (light) and
    `KvGnomeDark` (dark).

  Configuration:

    We instruct qt apps to use kvantum configurations by setting some
    environment variables (see the uwsm module).

    When we want to change between dark and light variants all we need to do is
    update `/home/{USER}/.config/Kvantum/kvantum.kvconfig` (see the script that
    changes themes).
*/
