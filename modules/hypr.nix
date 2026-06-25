{
  user,
  repoPath,
  # currentThemePath,
  ...
}:
{
  # Hyprland is initialized automatically via `~/.zprofile` (zsh module).
  programs.hyprland = {
    enable = true;
    withUWSM = true; # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm
  };

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      services = {
        elephant.enable = true;
        walker = {
          enable = true;
          systemd.enable = true;
        };
      };

      home = {
        file = {
          ".config/hypr" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/hypr";
            force = true;
          };
          ".config/elephant" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/elephant";
            force = true;
          };
          ".config/walker/config.toml" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/walker.toml";
            force = true;
          };
        };

        packages = with pkgs; [
          # hyprland # Dynamic tiling Wayland compositor that doesn't sacrifice on its looks
          # uwsm # Universal wayland session manager
          hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
          hyprtoolkit # A modern C++ Wayland-native GUI toolkit
          nautilus # File manager for GNOME
          wev # Wayland event viewer (keycodes)
          wl-clip-persist # Keep Wayland clipboard even after programs close
          wl-clipboard # Command-line copy/paste utilities for Wayland
          libqalculate # Advanced calculator library (!elephant)
        ];
      };
    };
}
