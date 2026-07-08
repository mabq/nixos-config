# XDG Desktop Portals

TODO: CHECK `/run/current-system/sw/share/xdg-desktop-portal`

When using minimal wayland compositors like Hyprland, you need to manually assemble the pieces that a full desktop environment usually provides out of the box.

To understand what portals do, it helps to look at the problems they were designed to solve: security and standardization.


## The Problem: Wayland's Strict Isolation

In the older X11 system, any application could look at what other applications were doing. An app could easily record your entire screen or log your keystrokes without asking permission. Wayland was built to fix this by sandboxing applications. In Wayland, an application only knows about its own window; it cannot see the rest of the screen or interact with the core system without explicit permission.

Furthermore, applications are increasingly distributed as sandboxed packages (like Flatpaks), which are actively blocked from accessing your user files or hardware directly.

So, if a sandboxed app or a strictly contained Wayland app needs to open a file, share your screen on a Discord call, or print a document, how does it do it safely?


## The Solution: xdg-desktop-portal

Instead of letting the application dig into your system to grab a file or capture the screen, the application talks to a standardized middleman: `xdg-desktop-portal`.

Think of `xdg-desktop-portal` as a hotel concierge.

The application (the guest) goes to the concierge and says, "I need to ask the user to pick a file to open."

The application does not know or care how the file picker is drawn or what toolkit (Qt, GTK) is used.

The concierge steps outside the application's sandbox, opens a secure file picker dialogue, lets the user select the file, and then hands only that specific file back to the application.


## Why you need many portals?

### xdg-desktop-portal (frontend)

This is the universal API. It provides the standard D-Bus interface that all applications (Firefox, OBS, Telegram, etc.) talk to. Every system using portals has this exact same package.

### xdg-desktop-portal-hyprland (backend)

The frontend concierge doesn't actually know how to take a screenshot or record a screen in Hyprland. It needs a specialized worker that speaks Hyprland's specific language.

When an application asks the frontend to share the screen, the frontend delegates that task to `xdg-desktop-portal-hyprland`, which talks to the Hyprland compositor to actually grab the video frames.

### xdg-desktop-portal-gtk (backend)

A compositor like Hyprland is purely concerned with drawing windows and capturing the screen. It does not have a built-in user interface for things like a file picker, a font chooser, or a printing dialog.

Because of this, `xdg-desktop-portal-hyprland` only handles Hyprland-specific tasks (primarily screen sharing and global shortcuts). For everything else, it relies on a fallback backend. This is why you will almost always install `xdg-desktop-portal-gtk` alongside it.


## Example on how they work together?

  1. A Qt application realizes you clicked "Open File".

  2. Because you set `QT_QPA_PLATFORMTHEME=xdgdesktopportal`, Qt does not use its own file picker. Instead, it asks the central `xdg-desktop-portal` service for a file.

  3. The central portal service routes that request to the `xdg-desktop-portal-gtk` backend.

  4. `xdg-desktop-portal-gtk` generates a GTK3/GTK4 file chooser dialog.

  5. You select your file in that GTK window, and the portal securely hands the file path back to your Qt application.

By using po-tals, you ensure that every application on your system (regardless of whether it was built with Qt, GTK, or Electron, and regardless of whether it is a Flatpak or a native Nix package) interacts with your system securely and uses the exact same unified dialogues.

