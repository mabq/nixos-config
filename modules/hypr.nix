{ user, repoPath, ... }:
{
  imports = [
    ./hypr-uwsm.nix
    ./hypr-cursor.nix
    ./hypr-gtk.nix
    ./hypr-qt.nix
  ];

  # This option automatically enables critical components needed to run
  # Hyprland properly, such as polkit, xdg-desktop-portal-hyprland, graphics
  # drivers, fonts, dconf, xwayland, and adding a proper Desktop Entry to the
  # Display Manager (which I do not use).
  programs.hyprland.enable = true;

  home-manager.users.${user} =
    {
      pkgs,
      config,
      ...
    }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          xdg-desktop-portal-gtk # See "xdg-desktop-portal" in notes directory.

          # -- Launcher --
          elephant # Data provider service and backend for building custom application launchers (!walker)
          walker # Wayland-native application runner
          libqalculate # Advanced calculator library (!elephant)

          # -- Hypr utils --
          # hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
          # hyprpwcenter # A GUI Pipewire control center
          # hyprsysteminfo # Tiny qt6/qml application to display information about the running system
          hyprpicker # Wlroots-compatible Wayland color picker that does not suck
          hyprpolkitagent # Polkit authentication agent written in QT/QML
          hyprshutdown # A graceful shutdown utility for Hyprland
          hyprtoolkit # A modern C++ Wayland-native GUI toolkit

          # -- Must have --
          wl-clip-persist # Keep Wayland clipboard even after programs close
          wl-clipboard # Command-line copy/paste utilities for Wayland

          # -- Others --
          nautilus # File manager for GNOME
          wev # Wayland event viewer (keycodes)
        ];

        file = {
          ".config/elephant" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/elephant";
            force = true;
          };
          ".config/walker" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/walker";
            force = true;
          };
          ".config/hypr" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/hypr";
            force = true;
          };
        };
      };

    };
}
