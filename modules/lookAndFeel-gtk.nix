{ pkgs, user, ... }:
{
  home-manager.users.${user} =
    { ... }:
    {
      home = {
        packages = with pkgs; [
          dconf # Essential: The reliable backend tool for live adjustments
          xdg-desktop-portal-gtk # This is what communicates apps that `dconf` settings have changed

          # glib # Provides the `gsettings` command to change GTK themes on the fly
          # gsettings-desktop-schemas # Provides the themes/interface schemas required by `gsettings`

          # GTK Themes
          gnome-themes-extra # Adwaita theme

          # Icon Themes
          whitesur-icon-theme
        ];
      };
    };
}

/*
  Everything depends on how the application was built (GTK3 vs. GTK4) and how
  it communicates with the system.

  `GTK_THEME` variable:
    If set, any GTK3 application launched by Hyprland will look at that
    variable and use that theme.

    Only works for GTK3. GTK4 and Libadwaita apps completely ignore it.

    It cannot update an application that is already running; it only applies at
    launch.

  `settings.ini` file:
    This is where GTK applications traditionally look for GTK configurations
    when running outside of GNOME.

    When a GTK app starts, it checks these files:
     `~/.config/gtk-3.0/settings.ini`
     `~/.config/gtk-4.0/settings.ini`

  dconf & gsettings
    dconf is a low-level key-value database used by the GNOME desktop.
    Check current settings with `dconf dump /org/gnome/desktop/interface/`

    gsettings is a high-level command-line frontend to modify it.

    GNOME applications don't read settings.ini files; they query the
    dconf database to see what theme they should use.

    The gsettings "No installed schemas" error:
      In NixOS, applications cannot look into global directories like
      /usr/share/glib-2.0/schemas because they don't exist. For
      gsettings to work in a terminal, it needs an environment
      variable called XDG_DATA_DIRS to point to the exact Nix store
      path where gsettings-desktop-schemas is installed. When you
      just install the package, your shell doesn't automatically get
      that path mapped.

    dconf commands succeed but do nothing:
      You successfully wrote a key to the dconf database, but no one
      was listening. For a GTK app to dynamically change its theme
      when a dconf value changes, a background daemon called
      xdg-desktop-portal-gtk must be running. This daemon acts as a
      bridge: it watches dconf and alerts Wayland applications that
      the theme has changed. Without it, your dconf writes are just
      screaming into the void.

    The Home Manager's gtk module automatically:
      Writes the `settings.ini` files for GTK3 and GTK4. Generates the
      correct dconf database entries. Packages the schemas so they
      are visible to your user session.
*/
