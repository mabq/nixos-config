{ user, ... }:
{
  home-manager.users.${user} =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          bibata-cursors # Cursor theme
        ];
      };
    };
}

/*
  Environment variables:
  ======================

    The following env variables are set by uwsm (these are read by Hyprland to
    set the default cursor theme/size):

      XCURSOR_THEME="Bibata-Modern-Ice"
      XCURSOR_SIZE=20

    See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/#theming-related-variables

  dconf:
  ======

    We must also set dconf cursor settings, otherwise LibreOffice randomly
    switches between XCURSOR theme and whatever cursor theme GTK sets as
    default.

    We do this in the Bash script that changes themes.

  Cursor themes:
  ==============

    The nix repository has a lot of cursor theme packages.

    Check currently available cursor themes in:

      `/etc/profiles/per-user/mabq/share/icons/` — installed with Home-manager
      `/run/current-system/sw/share/icons/` — installed with NixOS

    Bibata cursors are pretty nice and are supported by all apps.
*/
