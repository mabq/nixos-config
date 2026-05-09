{
  config, # home-manager options, not NixOS options
  lib,
  pkgs,
  user,
  profile,
  projectName,
  repoPath,
  ...
}: let
  theme = "catppuccin"; # must match one of the directory names in the themes folder

  repoUserPath = "${repoPath}/users/${user}";
  configPath = "${repoUserPath}/config";
  currentThemePath = "/home/${user}/.config/${projectName}/current/theme";

  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;

  # Helper function to force-enable all files in an attribute set
  forceFiles = fileSet: lib.mapAttrs (name: value: value // {force = true;}) fileSet;
in {
  home = {
    file = forceFiles {
      ".zshenv".text = ''
        # Be careful what you put in this file, it affects every zsh invocation (including scp, rsync, etc).
        setopt NO_GLOBAL_RCS # --- Ignore zsh global config files, except `/etc/zshenv` which is read before this file.
        ZDOTDIR="${repoUserPath}/config/zsh" # --- Source zsh config files directly from the repository. No need to export.
        export REPO_USER_PATH="${repoUserPath}" # --- Hard-coded into some config files.
      '';

      # Configurations in files created with mkOutOfStoreSymlink do not need a system rebuild
      ".config/nvim".source = mkOutOfStoreSymlink "${configPath}/nvim";
      ".config/git/config".source = mkOutOfStoreSymlink "${configPath}/.gitconfig";
      ".config/btop/btop.conf".source = mkOutOfStoreSymlink "${configPath}/btop.conf";
      ".config/starship.toml".source = mkOutOfStoreSymlink "${configPath}/starship.toml";
      ".config/tmux/tmux.conf".source = mkOutOfStoreSymlink "${configPath}/tmux.conf";

      # Theme related files (change the theme by just updating the pointer).
      ".config/${projectName}/current/theme".source = mkOutOfStoreSymlink "${repoPath}/themes/${theme}";
      ".config/btop/themes/current.theme".source = mkOutOfStoreSymlink "${currentThemePath}/btop.theme";
    };

    homeDirectory = "/home/${user}"; # TODO: check if needed

    packages = with pkgs; [
      age # Modern encryption tool with small explicit keys
      atuin # Replacement for a shell history
      bat # Cat clone with syntax highlighting and Git integration
      bluetui # TUI for managing bluetooth on Linux [4]
      btop # Monitor of resources
      caligula # User-friendly, lightweight TUI for disk imaging
      exfatprogs # exFAT filesystem userspace utilities
      eza # Modern, maintained replacement for ls
      fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
      fd # Simple, fast and user-friendly alternative to find
      ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
      fzf # Command-line fuzzy finder
      gh # GitHub CLI tool
      git # Distributed version control system
      imagemagick # Software suite to create, edit, compose, or convert bitmap images
      iperf # Tool to measure IP bandwidth using UDP or TCP
      lazygit # Simple terminal UI for git commands
      mpv # General-purpose media player, fork of MPlayer and mplayer2
      ncdu # Disk usage analyzer with an ncurses interface
      neovim # Vim text editor fork
      nixd # Feature-rich Nix language server interoperating with C++ nix
      nix-tree # Interactively browse a Nix store paths dependencies
      opencode # AI coding agent built for the terminal
      parted # Create, destroy, resize, check, and copy partitions
      pciutils # Provides the `lspci` command
      ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
      starship # Customizable prompt for any shell
      tldr # Simplified and community-driven man pages
      tmux # Terminal multiplexer
      unzip # Extraction utility for archives compressed in .zip format
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      whois # Intelligent WHOIS client from Debian
      yazi # Blazing fast terminal file manager written in Rust, based on async I/O
      zoxide # Fast cd command that learns your habits
      zsh-autosuggestions # Fish shell autosuggestions for Zsh
      zsh-history-substring-search # Fish shell history-substring-search for Zsh
      zsh-syntax-highlighting # Fish shell like syntax highlighting for Zsh
      # bitwarden-cli # Secure and free password manager for all of your devices
      # dnsutils # Domain name server - provides the `dig` command
      # ngrep # Network packet analyzer - use `sudo ngrep port <port>` to check if a port is being used
      # inetutils # Collection of common network programs
      # inxi # Full featured CLI system information tool
      # ------------------------------------------------------------------------
      # alacritty
      # avahi # mDNS/DNS-SD implementation (Bonjour)
      # brightnessctl
      # chromium
      # cups
      # cups-browsed
      # cups-filters
      # cups-pdf
      # evince
      # fcitx5
      # fcitx5-gtk
      # fcitx5-qt
      # ffmpegthumbnailer
      # fontconfig
      # gnome-calculator
      # gnome-keyring
      # gnome-themes-extra
      # grim
      # gpu-screen-recorder
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
      # jq
      # kdenlive
      # kernel-modules-hook
      # kvantum-qt5
      # libsecret
      # libyaml
      # libqalculate
      # libreoffice-fresh
      # llvm
      # localsend
      # mako
      # mariadb-libs
      # mise
      # nautilus
      # nautilus-python
      # gnome-disk-utility
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
      # spotify
      # socat
      # sushi
      # swaybg
      # swayosd
      # system-config-printer
      # tree-sitter-cli
      # tobi-try
      # ttf-ia-writer
      # ttf-jetbrains-mono-nerd
      # typora
      # ufw
      # ufw-docker
      # uwsm
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
#
# 3. This functions creates a symlink pointing to the given config file in the repository,
#    instead of creating an inmutable copy of the file in the Nix Store and point to it.
#    This way you can make edits to those files in the local machine and see those changes
#    inmediately, without needing to rebuild NixOS or even fetch the repository.
#    If you like the changes, commit and push. Otherwise just reset.
#
# 4. In order for bluetui to work the pipewire user service must be active, try executing
#    `wiremix` to start it.

