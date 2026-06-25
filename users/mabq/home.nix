{
  config, # home-manager options, not NixOS options
  pkgs,
  user,
  ...
}:
{
  home = {
    homeDirectory = "/home/${user}"; # TODO: check if needed

    username = user; # TODO: check if needed

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.11";

    packages = with pkgs; [
      brave # Privacy-oriented browser for Desktop and Laptop computers
      # alacritty
      # avahi # mDNS/DNS-SD implementation (Bonjour)
      # bitwarden-cli # Secure and free password manager for all of your devices
      # brightnessctl
      # chromium
      # cups
      # cups-browsed
      # cups-filters
      # cups-pdf
      # dnsutils # Domain name server - provides the `dig` command
      # evince
      # fcitx5
      # fcitx5-gtk
      # fcitx5-qt
      # ffmpegthumbnailer
      # fontconfig
      # gnome-calculator
      # gnome-disk-utility
      # gnome-keyring
      # gnome-themes-extra
      # gpu-screen-recorder
      # grim
      # gum
      # gvfs-mtp
      # gvfs-nfs
      # gvfs-smb
      # hypridle
      # hyprland
      # hyprland-guiutils
      # hyprland-preview-share-picker
      # hyprlock
      # hyprpicker
      # hyprsunset
      # imagemagick
      # imv
      # inetutils # Collection of common network programs
      # inxi # Full featured CLI system information tool
      # jq
      # kdenlive
      # kernel-modules-hook
      # kvantum-qt5
      # libqalculate
      # libreoffice-fresh
      # libsecret
      # libyaml
      # llvm
      # localsend
      # mako
      # mariadb-libs
      # mise
      # nautilus
      # nautilus-python
      # ngrep # Network packet analyzer - use `sudo ngrep port <port>` to check if a port is being used
      # noto-fonts
      # noto-fonts-cjk
      # noto-fonts-emoji
      # nss-mdns
      # obs-studio
      # obsidian
      # omarchy-walker
      # pamixer
      # pinta
      # playerctl
      # plocate
      # polkit-gnome
      # postgresql-libs
      # power-profiles-daemon
      # python-gobject
      # python-poetry-core
      # python-terminaltexteffects
      # qt5-wayland
      # ruby
      # rust
      # satty
      # signal-desktop
      # slurp
      # socat
      # spotify
      # sushi
      # swaybg
      # swayosd
      # system-config-printer
      # tobi-try
      # tree-sitter-cli
      # ttf-ia-writer
      # ttf-jetbrains-mono-nerd
      # typora
      # ufw
      # ufw-docker
      # waybar
      # wireless-regdb
      # wl-clipboard
      # woff2-font-awesome
      # xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland
      # xdg-terminal-exec
      # xmlstarlet
      # xournalpp
      # yaru-icon-theme
      # yay
    ];
  };

  xdg = {
    enable = true;
    # Manage xdg directories, e.g.  ~/.config, ~/.local/share, etc.

    userDirs = {
      enable = true;
      setSessionVariables = true; # Create XDG variables automatically.
      createDirectories = true; # Automatically create ~/Downloads, etc.
      extraConfig = {
        SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };

    # -- Default apps
    # Declarative way of configuring `~/.config/mimeapps.list`. Changes
    # instroduced with the imperative command `xdg-mime default ...` will be
    # overriden on next reboot.
    #
    # To setup a default app, first check the MIME type of the file with
    # `xdg-mime query filetype <file>`, then check the available `.desktop`
    # files in directories included in $XDG_DATA_DIRS. Finally, link a MIME
    # type to a .desktop file here.

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "brave-browser.desktop";
        "application/pdf" = "brave-browser.desktop";
        "image/png" = "imv.desktop";
      };
    };

    desktopEntries = {
      # my-custom-app = {
      #   name = "My Custom App";
      #   genericName = "Text Editor";
      #   exec = "my-script %U";
      #   terminal = false;
      #   categories = [ "Application" "Development" ];
      #   icon = "accessories-text-editor";
      # };
    };
  };
}

# [4] In order for bluetui to work the pipewire user service must be active,
# try executing `wiremix` to start it.
