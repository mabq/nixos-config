# Environment Variables

Processes form an inversed tree. Each has a single parent.

For example, if you start Hyprland by typing `Hyprland` in your TTY (in a
systemd-based Linux distro), your process tree would look like this:

```
 A = `systemd`               Systemd is the first process in user space (PID1)
 │
 ├─ B = zsh                  The default shell is automatically initialized by PAM
 │  │
 │  └─ C = Hyprland          Manually/Programatically started from the shell
 │
 └─ D = `systemd --user`     (Initialized by systemd)
    │
    └─ E = `waybar`          (Initialized as a background user service)
```


## Inheritance is strictly a one-way street
-------------------------------------------

When a parent process spawns a child (typically via a system call called
`fork`), the operating system creates a complete, independent copy of the
parent's environment block for the child to use.

Because the child process is operating in its own isolated memory space, any
modifications it makes to any inherited variable (e.g. `export PATH="..."`) are
completely invisible to the parent.

The new value will only apply to that specific child process, and any future
children that process spawns. The parent's value of that variable remains
exactly as it was.


## Why UWSM
-----------

When Hyprland starts up, it generates critical environment variables (e.g.
`WAYLAND_DISPLAY=wayland-1`). Because of the strict top-down inheritance rules,
Hyprland (C) has that variable, but Waybar (E) only inherits from D and A.
Therefore, it has no idea `WAYLAND_DISPLAY` exists. When Waybar tries to
launch, it can't find the display server and crashes.

Basically, without UWSM your environment is split into silos. Your shell has
one set of variables, Hyprland has another, and `systemd --user` is missing
critical variables.

By setting our environment variables with UWSM we ensure that every part of
the system (whether launched via terminal, keyboard shortcut, or background
service) has access to the same environment variables.

For more info read uwsm notes file.
