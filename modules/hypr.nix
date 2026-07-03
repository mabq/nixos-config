{
  user,
  repoPath,
  ...
}:
{
  imports = [
    # ./hypr-theme-gtk.nix
    # ./hypr-theme-qt.nix
  ];

  programs.hyprland = {
    # This option automatically enables critical components needed to run
    # Hyprland properly, such as polkit, xdg-desktop-portal-hyprland, graphics
    # drivers, fonts, dconf, xwayland, and adding a proper Desktop Entry to the
    # Display Manager (which I do not use).
    enable = true;

    # Use Univernal Wayland Session Manager
    # Read explanation below [1]
    withUWSM = true;
  };

  home-manager.users.${user} =
    {
      pkgs,
      config,
      ...
    }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        file = {
          ".config/uwsm/env" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/uwsm/env";
            force = true;
          };
          ".config/uwsm/env-hyprland" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/uwsm/env-hyprland";
            force = true;
          };
          # ".config/uwsm/env.d/hm-session-vars" = {
          #   source = mkOutOfStoreSymlink "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
          #   force = true;
          # };

          ".config/elephant" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/elephant";
            force = true;
          };
          ".config/walker" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/walker";
            force = true;
          };
          ".config/hypr" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/hypr";
            force = true;
          };
        };

        packages = with pkgs; [
          elephant # Data provider service and backend for building custom application launchers (!walker)
          gnome-themes-extra # Provides Adwaita color theme and icon theme
          hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
          hyprtoolkit # A modern C++ Wayland-native GUI toolkit
          libqalculate # Advanced calculator library (!elephant)
          nautilus # File manager for GNOME
          obs-studio # Free and open source software for video recording and live streaming
          walker # Wayland-native application runner
          wev # Wayland event viewer (keycodes)
          wl-clip-persist # Keep Wayland clipboard even after programs close
          wl-clipboard # Command-line copy/paste utilities for Wayland
        ];

      };

    };
}

/*
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
*/

/*
    [2] Icons themes

    Most Linux distros (including NixOS) include the `hicolor` icon theme by default,
    you can find it in `/run/current-system/sw/share/icons/hicolor`.

    Icon themes you install with Home-manager can be found in
    `/etc/static/profiles/per-user/mabq/share/icons/`.
*/

/*
    UI Toolkits:

      Linux is decentralized nature, so there is no universal theming system
      like Apple's UIKit or Microsoft's WinUI.

      UI toolkits where developed by Linux distros to facilitate the
      development of graphical applications. Every Linux GUI application is
      free to choose a UI toolkit (Qt, GTK, FLTK, Electron, etc.) or implement
      its own rendering from scratch.

      Apps are also free to override some of the toolkit configuration options,
      for example; Firefox uses GTK for some integration (file dialogs, fonts,
      etc.), but much of its interface is drawn by Firefox itself.

      So the toolkit is the mechanism through which desktop-wide appearance
      settings are applied, but if an application bypasses that mechanism, the
      desktop has little or no control over its appearance.

      The most popular toolkits are GTK and Qt.

        GTK (GTK2, GTK3, GTK4)
          Created by Gnome, but works everywhere.
          Used by apps like Walker, Firefox, Gimp, Files.

        Qt (Qt5, Qt6)
          Created by KDE Plasma, but works everywhere.
          Used by apps like VLC, OBS Studio, qBittorrent, and Dolphin.

          Kvantum is a third-party theme engine that replaces the default way
          Qt draws its widgets (it only affects applications built on Qt). It
          does this by using sophisticated SVG graphics and advanced
          transparency effects to give Qt applications a much more polished,
          customizable, and modern look than the basic built-in Qt styles can
          provide. Note that Kvantum requires kvantum themes (normal QT themes
          are not supported).
          You have to manually tell your system to use "Kvantum" as the active
          Qt style.

      Read the following Archwiki link for more information:
        https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications

      The exact files vary slightly depending on versions and distributions,
      but the following covers the common setup:

        `~/.config/gtk-3.0/settings.ini` — for GTK 3
        `~/.config/gtk-4.0/settings.ini` — for GTK 3

      A practical setup:

        If you want a cohesive desktop without a desktop environment doing the
        work for you, a common manual setup is:

        GTK: `settings.ini` with your preferred GTK theme, icon theme, cursor
        theme, and font.

        Qt: qt6ct (or qt5ct) configured to use the same icon
        theme and font, plus a matching style or a Kvantum theme.

        Icons: Use a single icon pack (e.g. Papirus) for both GTK and Qt.

        Cursor: Use one cursor theme system-wide.

        This won't cover applications like Firefox, Chromium, Electron apps, or
        Blender—their main interfaces have separate theming mechanisms—but it
        will make most native GTK and Qt applications look consistent.

      In Wayland, applications ask the XDG Desktop Portal what the system theme
      is, if your portal isn't configured, your Flatpaks will remain bright
      white-themed even if your system is dark-themed.
*/
