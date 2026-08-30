{
  pkgs,
  user,
  repoDir,
  ...
}:
{
  imports = [
    ./dependencies/foot.nix
    # ./dependencies/hypr-uwsm.nix
    # ./theme-desktop.nix
  ];

  # Enable Hyprland
  #  https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # [1]
  };

  home-manager.users.${user} =
    { config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          xdg-desktop-portal-gtk # See "xdg-desktop-portal" in notes directory.

          brave # Privacy-oriented browser for Desktop and Laptop computers
          fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
          nautilus # File manager for GNOME
          libqalculate # Advanced calculator library (!elephant)
          wev # Wayland event viewer (keycodes)
          xlsclients # Utility to list client applications running on a X11 display

          # -- Launcher --
          # INFO: Read [Service Management](https://nixos.org/manual/nixos/stable/#sec-systemctl)
          # elephant # Data provider service and backend for building custom application launchers (!walker)
          # walker # Wayland-native application runner

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
        ];

        file = {
          # ".config/elephant" = {
          #   source = mkOutOfStoreSymlink "${repoDir}/config/elephant";
          #   force = true;
          # };
          # ".config/walker" = {
          #   source = mkOutOfStoreSymlink "${repoDir}/config/walker";
          #   force = true;
          # };
          ".config/hypr" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/hypr";
            force = true;
          };
        };
      };

    };
}

/*
  [1] Force apps to use Wayland

  Variables set with `environment.sessionVariables` are written to `/etc/set-environment`
  which is sourced by all shells by default in NixOS and also pushed to systemd user
  ;

  https://wiki.hypr.land/Getting-Started/Master-Tutorial/#force-apps-to-use-wayland
*/
