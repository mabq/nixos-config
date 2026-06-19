{
  config, # home-manager options, not NixOS options
  lib,
  pkgs,
  user,
  projectName,
  repoPath,
  configPath,
  currentThemePath,
  theme,
  forceFiles,
  ...
}:
let
  # TODO: can I access directly under lib?
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home = {
    file = forceFiles {
      # Configurations in files created with mkOutOfStoreSymlink do not need a system rebuild
      ".config/btop/btop.conf".source = mkOutOfStoreSymlink "${configPath}/btop.conf";
      ".config/fontconfig/fonts.conf".source = mkOutOfStoreSymlink "${configPath}/fonts.conf";
      ".config/foot/foot.ini".source = mkOutOfStoreSymlink "${configPath}/foot.ini";
      ".config/git/config".source = mkOutOfStoreSymlink "${configPath}/.gitconfig";
      ".config/hypr".source = mkOutOfStoreSymlink "${configPath}/hypr"; # -- whole dir
      ".config/lazygit/config.yml".source = mkOutOfStoreSymlink "${configPath}/lazygit.yml";
      ".config/nvim".source = mkOutOfStoreSymlink "${configPath}/nvim"; # -- whole dir
      ".config/starship.toml".source = mkOutOfStoreSymlink "${configPath}/starship.toml";
      ".config/tmux/tmux.conf".source = mkOutOfStoreSymlink "${configPath}/tmux.conf";
      ".config/elephant".source = mkOutOfStoreSymlink "${configPath}/elephant";
      ".config/walker/config.toml".source = mkOutOfStoreSymlink "${configPath}/walker.toml";

      # Theme files (should work by just changing a single symlink).
      ".config/${projectName}/current/theme".source = mkOutOfStoreSymlink "${repoPath}/themes/${theme}";
      ".config/btop/themes/current.theme".source = mkOutOfStoreSymlink "${currentThemePath}/btop.theme";
      "${configPath}/nvim/lua/plugins/theme.lua".source =
        mkOutOfStoreSymlink "${currentThemePath}/neovim.lua";
      # TODO: launcher theme once we decide which launcher we are going to use
    };

    homeDirectory = "/home/${user}"; # TODO: check if needed

    packages = with pkgs; [
      # luajit # High-performance JIT compiler for Lua 5.1 (!neovim)
      # luarocks # A package manager for Lua modules (!neovim)
      age # Modern encryption tool with small explicit keys
      bash-language-server # Language server for Bash
      biome # Toolchain of the web (!neovim)
      # TODO: Bluetooth: Move this package to a module with bluetooth system config
      bluetui # TUI for managing bluetooth on Linux [4]
      btop # Monitor of resources
      caligula # User-friendly, lightweight TUI for disk imaging
      delta # Syntax-highlighting pager for git (!lazygit)
      exfatprogs # exFAT filesystem userspace utilities
      fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
      gcc # GNU Compiler Collection
      gh # GitHub CLI tool
      git # Distributed version control system
      gnumake # Tool to control the generation of non-source files from sources (!neovim)
      iperf # Tool to measure IP bandwidth using UDP or TCP
      lazygit # Simple terminal UI for git commands (!neovim)
      lua-language-server # Language server that offers Lua language support (!neovim)
      mpv # General-purpose media player, fork of MPlayer and mplayer2
      ncdu # Disk usage analyzer with an ncurses interface
      neovim # Vim text editor fork
      nix-tree # Interactively browse a Nix store paths dependencies
      nixd # Feature-rich Nix language server interoperating with C++ nix (!neovim)
      nixfmt # Official formatter for Nix code (!neovim)
      pciutils # Provides the `lspci` command
      shfmt # Shell parser and formatter (!neovim)
      starship # Customizable prompt for any shell
      stylua # Opinionated Lua code formatter (!neovim)
      tldr # Simplified and community-driven man pages
      tmux # Terminal multiplexer
      tree-sitter # Parser generator tool and an incremental parsing library (!neovim)
      unzip # Extraction utility for archives compressed in .zip format
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      whois # Intelligent WHOIS client from Debian
      yazi # Blazing fast terminal file manager written in Rust, based on async I/O (!neovim)
      # ------------------------------------------------------------------------
      # Desktop
      # ------------------------------------------------------------------------
      # hyprland # Dynamic tiling Wayland compositor that doesn't sacrifice on its looks
      # uwsm # Universal wayland session manager
      brave # Privacy-oriented browser for Desktop and Laptop computers
      foot # Fast, lightweight and minimalistic Wayland terminal emulator
      hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
      hyprtoolkit # A modern C++ Wayland-native GUI toolkit
      jetbrains-mono # Typeface made for developers
      kitty # Fast, feature-rich, GPU based terminal emulator
      nautilus # File manager for GNOME
      nerd-fonts.symbols-only # Just the Nerd Font Icons
      wev # Wayland event viewer (keycodes)
      wl-clip-persist # Keep Wayland clipboard even after programs close
      wl-clipboard # Command-line copy/paste utilities for Wayland
      libqalculate # Advanced calculator library (!elephant)
      # ------------------------------------------------------------------------
      # Later
      # ------------------------------------------------------------------------
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

    username = user; # TODO: check if needed

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.11";
  };

  services = {
    elephant.enable = true;
    walker = {
      enable = true;
      systemd.enable = true;
    };
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
