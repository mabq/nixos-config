# vim: filetype=sh

# This file is read only once (when you login into the system)

# Automatically start hyprland after login via the tty
#   https://wiki.hypr.land/Useful-Utilities/Systemd-start/#in-tty
if [[ -z "$TMUX" ]]; then
  if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    if uwsm check may-start; then
      exec uwsm start hyprland.desktop
    fi
  fi
fi
