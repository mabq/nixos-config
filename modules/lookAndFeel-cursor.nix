{ user, ... }:
{
  home-manager.users.${user} =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          bibata-cursors # Material Based Cursor Theme
        ];
      };
    };
}

/*
  Cursor themes are installed in:

    `/etc/static/profiles/per-user/{USER}/share/icons/` - (Home-manager)
    `/run/current-system/sw/share/icons/` - (NixOS)

  Important!

    Cursor theme/size are set with environment variables (see uwsm module).

    Must also set cursor theme/size `dconf` options because of a bug with
    Libreoffice, this is done automatically by the theme script using the
    `XCURSOR_THEME` and `XCURSOR_SIZE` environment variables.
*/
