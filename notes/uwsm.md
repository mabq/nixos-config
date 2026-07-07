# UWSM


## What is UWSM?

UWSM stand for Universal Wayland Session Manager.

Universal because


## What are the benefits?

In practical terms, when using a minimal Wayland compositor like Hyprland, using UWSM has the following benefits.

### A consistent way to launch different Wayland compositors

### Standardized session startup


### Cleaner environment variable handling


### Integration with systemd --user


### Proper shutdown of session processes


### Better compatibility with desktop services



    Why UWSM:

      Without UWSM (Universal Wayland Session Manager), every single app you open
      from inside Hyprland (terminal, browser, etc) becomes a "child process"
      tied directly to Hyprland.

      UWSM gives you clean isolation: Instead of your browser and terminal
      running "inside" Hyprland, UWSM tells systemd to launch them as independent
      units. If Hyprland crashes, your apps don't violently die in the
      background, they can shut down cleanly, allowing browsers like Chromium to
      save your tabs.

      Flawless Environment Sharing: It automatically shares critical display
      variables (like `WAYLAND_DISPLAY` and `XDG_CURRENT_DESKTOP`) to background
      daemons. This solves the classic Wayland headache where things like
      screen-sharing, calculators, and system notifications (xdg-desktop-portal)
      randomly refuse to open. The value for `XDG_CURRENT_DESKTOP` is obtained
      from the `DesktopNames` attribute from the `hyprland.desktop` file.

      Graceful Exit: Instead of forcefully killing the graphical server, typing
      `uwsm stop` triggers a perfectly orchestrated system shutdown sequence
      where background bars, wallpapers, and apps close down in the correct
      order.

  [1] withUWSM

     This option enables `programs.uwsm.enable` and creates 2 `.desktop` files
      in `/run/current-system/sw/share/wayland-sessions/`:

      1.`hyprland.desktop` contains `Exec=Hyprland`. UWSM reads this file to
      figure out what binary it is wrapping and how to set up the systemd
      environment variables. We absolutely need this file.

      2.`hyprland-uwsm.desktop` is exclusively meant for Display Managers (like
      SDDM, Ly, or GDM). Since we don't use a display manager we replicate the
      behaviour of this file in `~/.zprofile` (see the zsh module) to
      automatically launch hyprland after authenticating.

    Understand the context:

      The kernel prepares the hardware; systemd prepares the software.

      1. The boot loader (GRUB or systemd-boot) loads the Linux kernel into
      memory and hands control over to it.

      2. The kernel initializes the hardware (CPU, memory, storage controllers,
      GPU) and then looks for the very first program to run in user-space
      (`/sbin/init`, which on modern systems is a symlink to systemd) and
      executes it as PID 1.

      3. Systemd starts all your software services, mounts secondary disks (using
      `/etc/fstab`), starts the network, and eventually spawns a virtual console
      on `/dev/tty1` for authentication.

      4. Once authenticated, systemd uses `/etc/passwd` to discover the default
      login shell (in our case `zsh`). Before the login shell gives you an
      interactive prompt, it reads `~/.profile` which we configure in the zsh
      module to automatically launch hyprland.

      5. UWSM scans your system for the `hyprland.desktop` file, opens it, reads
      how to launch Hyprland, intercepts all your current shell environment
      variables, and pushes them into systemd's memory. Keep in mind that
      variables in `~/.zshrc` (or its sourced files) are not available yet at
      this point, so they won't be included. Put all your environment variables
      in `~/.config/uwsm/env` insted on zsh files.

      6. UWSM tells your systemd user instance to activate the universal Wayland
      graphical target (`graphical-session.target`), this is the standard,
      universal systemd target used across all Linux distributions to signal that
      a graphical user interface is fully up and running.

      7. Systemd loads all units associated to that target and nest them into
      dedicated cgroup slices. `wayland-session@hyprland.target` is the primary
      target activated by UWSM. `wayland-wm@hyprland.service` is the systemd
      wrapper unit that actually targets and opens the Hyprland binary.

      7. Hyprland starts up inside the systemd scope. It initializes your GPU,
      sets up workspaces, and reads your custom configurations in
      `~/.config/hypr/hyprland.lua`

      8. Make sure you set hyprland keybinds to use `uwsm app -- <command>` to
      make UWSM signal systemd to launch that app inside an isolated transient
      unit.

