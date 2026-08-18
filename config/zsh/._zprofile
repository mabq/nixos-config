# vim: filetype=sh

# Automatically start hyprland with UWSM.
#  https://wiki.hypr.land/Useful-Utilities/Systemd-start/#in-tty
#
# This file is read only by login shells (when you authenticate).
# Tmux new windows are considered login shells, so we need to skip those.
if [[ -z "$TMUX" ]]; then
  # Additionally make sure this only runs if we are on tty1.
  if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    # Make sure uwsm is available.
    # TODO: This should also check if hyprland is not already running (because you can get a new tty with Ctrl-Alt-f1/f7
    if uwsm check may-start; then
      # We don't use a display manager, which reads the file
      # `/run/current-system/sw/share/wayland-sessions/hyprland-uwsm.desktop`,
      # so we replicate its content here.
      #
      # The `-D Hyprland` flag tells UWSM to explicitly set:
      #  `XDG_CURRENT_DESKTOP=Hyprland`
      #  `XDG_SESSION_DESKTOP=Hyprland`
      #
      # The -e flag stands for exclusive. It tells UWSM: "Take the desktop
      # names I just specified with `-D` and discard any other conflicting
      # desktop variables."
      #
      # For more information read notes in the hyprland module.
      exec uwsm start -e -D Hyprland hyprland.desktop
    fi
  fi
fi
