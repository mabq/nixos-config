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
  Bibata works consistently across GTK, Qt, Electron, and most apps (X11/Wayland).

  Cursor theme and size are controled by environment variables, see the uwsm module.

  See available cursor themes in:
    `/etc/static/profiles/per-user/{USER}/share/icons/` - Installed with Home-manager
    `/run/current-system/sw/share/icons/` - Installed with NixOS
*/
