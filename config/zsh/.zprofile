# vim: filetype=sh

# This file is only read by login shells (when you authenticate).
#  Tmux new windows are considered login shells, skip.

# Automatically start hyprland with UWSM.
#  https://wiki.hypr.land/Useful-Utilities/Systemd-start/#in-tty
if [[ -z "$TMUX" ]]; then
  if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    # Skip if uwsm is not installed.
    if uwsm check may-start; then
      exec uwsm start hyprland.desktop
    fi
  fi
fi
