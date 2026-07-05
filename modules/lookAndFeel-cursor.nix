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
  Cursor theme and size is set with environment variables (see uwsm module).

  Cursor themes are installed in:
    `/etc/static/profiles/per-user/{USER}/share/icons/` - installed with Home-manager
    `/run/current-system/sw/share/icons/` - installed with NixOS

  dconf settings must be kept in sync with environment variables because of a
  LibreOffice bug (see the dconf theme script).
*/
