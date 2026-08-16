{
  config,
  user,
  ...
}:
let
  selectedTheme = config.my.theme.name;
  # `light.mode` is an empty file that should only exist in light themes
  hasLightMode = builtins.pathExists (../themes + "/${selectedTheme}/light.mode");
in
{
  options = { };
  config = {
    home-manager.users.${user} =
      { pkgs, ... }:
      {
        options = { };
        config = {
          home = {
            packages = with pkgs; [
              dconf # `dconf` command
              gnome-themes-extra # Adwaita GTK theme
              whitesur-icon-theme # Like them more than Adwaita icons
            ];
          };
          dconf.settings = {
            "org/gnome/desktop/interface" = {
              gtk-theme = if hasLightMode then "Adwaita" else "Adwaita-dark";
              color-scheme = if hasLightMode then "prefer-light" else "prefer-dark";
              icon-theme = if hasLightMode then "WhiteSur-light" else "WhiteSur-dark";
            };
          };
        };
      };
  };
}

/*
  GTK:
  ====

    UI toolkit developed by GNOME.

    Two versions currently used: GTK3 and GTK4.

    Apps that use GTK: Nautilus, Incscape, GIMP, LibreOffice (parts)

  dconf:
  ======

    dconf is the configuration system used by GTK and GNOME.

    The `dconf` command can be used to set the same settings that you would
    normally set via the system settings UI in a full desktop environment like
    GNOME.

    Check possible settings in:
      https://wiki.archlinux.org/title/GNOME#Configuration

    Check current dconf settings with:
      `dconf dump /org/gnome/desktop/interface/`

    Write a dconf settings with:
      `dconf write /org/gnome/desktop/interface/{OPTION} "{VALUE}"`

    Remove a dconf settings with:
      `dconf reset /org/gnome/desktop/interface/{OPTION}`

    We use a Bash script to update `dconf` settings every time we change
    themes. Unfortunatelly, dconf is strictly designed to read from a binary
    database, so we cannot configure it with plain text files in our themes
    directory (like we do with Kvantum for QT apps).

    For the application to reflect the theme change on the fly a proper
    configuration of xdg-desktop-portal is required (see hypr module).

  Environment variables:
  ======================

    While the `GTK_THEME` env variable is the easiest approach to set a GTK
    theme, it does not allow us to change themes on the fly.

    https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/#theming-related-variables

  GTK themes:
  ===========

    The nix repository has a lot of GTK theme packages.

    Check currently available GTK themes in:

      `/etc/profiles/per-user/mabq/share/themes/` — installed with Home-manager
      `/run/current-system/sw/share/themes/` — installed with NixOS

    The Adwaita theme is the default theme used by GNOME, so it is a little
    more polished than everything else.

  GTK icon themes:
  ================

    The nix repository has a lot of GTK icon theme packages.

    You can check currently available icon themes in:

      `/etc/profiles/per-user/mabq/share/icons/` — installed with Home-manager
      `/run/current-system/sw/share/icons/` — installed with NixOS

    I like WhiteSur icons more than Adwaita ones.
*/
