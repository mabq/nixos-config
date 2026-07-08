# UWSM

UWSM stand for Universal Wayland Session Manager (works with any wayland
compositor).


## Why UWSM?
------------

Without UWSM (Universal Wayland Session Manager), every single app you open
from inside Hyprland (terminal, browser, etc) becomes a "child process" tied
directly to Hyprland.

UWSM instructs systemd to launch them as independent units. If Hyprland
crashes, the apps don't violently die in the background, they can shut down
cleanly, allowing browsers like Chromium to save your tabs.

Additionally, UWSM ensures background daemons started with `systemd --user`
have access to critical variables ((like `WAYLAND_DISPLAY` and
`XDG_CURRENT_DESKTOP`). More info about this in environment variables notes.

Instead of forcefully killing the graphical server, typing `uwsm stop` triggers
a perfectly orchestrated system shutdown sequence where background bars,
wallpapers, and apps close down in the correct order.


## programs.hyprland.withUWSM (NixOS option)
--------------------------------------------

This option enables `programs.uwsm.enable` which creates the following files:

`/run/current-system/sw/share/wayland-sessions/hyprland.desktop`
  The `Exec=` attribute o this file points to the Hyprland executable in the
  Nix Store.

`/run/current-system/sw/share/wayland-sessions/hyprland-uwsm.desktop`
  Normally this file is used by Display Managers (like SDDM, Ly, or GDM) to
  launch Hyprland wrapped by UWSM.
  Since I don't use any Display Manager I use the value of its `Exec=` attribute
  in `~/.zprofile` to automatically launch Hyprland after login in the TTY.


## How it works
---------------

### Pre-Login (The System Scope)

Before you authenticate, the environment is strictly system-wide. None of the
variables in your home directory (shell configs, UWSM configs) apply here
because the system doesn't know who is logging in yet.

Systemd starts all system-level services; mounts secondary disks (using
`/etc/fstab`), starts network services, and eventually spawns a virtual console
on `/dev/tty1` running `getty`/`login` asking for your credentials on the TTY.


### Authentication (PAM & The User Systemd Scope)

The system uses PAM (Pluggable Authentication Modules) to verify you. Once PAM
approves, it begins setting up your user environment (see
`/etc/pam/environment`).

Before you even get a command prompt, PAM (specifically `pam_systemd`) tells
the main systemd process to spawn a new, separate instance of systemd just for
you.

This `systemd --user` process is spawned directly by `systemd`, not your shell,
so any background user service (Waybar, Dunst, Elephant) knows absolutely
nothing about environment variables set by the shell.


### The Shell (The Interactive Scope)

After PAM sets up your session, it looks in `/etc/passwd` for your default
shell, starts it and attaches it to the current TTY.

Before the login shell gives you an interactive prompt, it reads a set of
configuration files. This is documented in the zsh notes.

If you define a variable like `MOZ_ENABLE_WAYLAND=1` in `.bashrc`, the shell
knows about it. If you launch Firefox from that shell, Firefox inherits it. But
if a background service (launched by `systemd --user`) tries to launch Firefox,
it will fail to find that variable because `systemd --user` does not know about
that variable.

### Starting UWSM (The Bridge)

  1. We configured `~/.zprofile` (one of the files read by zsh at login) to
     automatically execute `uwsm start -e -D Hyprland hyprland.desktop`.

  2. UWSM reads its own configuration files (like `~/.config/uwsm/env`) to
     gather variables.

  3. UWSM scans your system for the `hyprland.desktop` file, opens it, reads
     how to launch Hyprland and instructs `systemd --user` to wrap Hyprland
     inside a systemd unit (specifically, a `.scope` or `.service` unit).
     Integrating the compositor into systemd's lifecycle tracking.

  4. When Hyprland starts, it generates critical runtime variables (like
     `WAYLAND_DISPLAY` and `HYPRLAND_INSTANCE_SIGNATURE`). UWSM captures these
     variables, combines them with the ones from its config files, and pushes
     them directly into the `systemd --user` environment and the *D-Bus*
     session environment.

  5. UWSM tells your systemd user instance to activate the universal Wayland
     graphical target (`graphical-session.target`), this is the standard,
     universal systemd target used across all Linux distributions to signal
     that a graphical user interface is fully up and running.

  6. `systemd --user` loads all units associated to that target and nest them
     into dedicated cgroup slices. Since all Hyprland related environment
     variables where available to `systemd --user`, all the processes started
     by it will also have them available.

Make sure you set hyprland keybinds to use `uwsm app -- <command>` to make UWSM
signal systemd to launch that app inside an isolated transient unit.
