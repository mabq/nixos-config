# Use `mkDefault`, these should be overidable.
{
  config,
  lib,
  pkgs,

  host,
  user,
  repoBranch,
  repoName,
  repoDir,
  repoThemeDir,
  localThemeDir,
  ...
}:
with lib;
{
  # ----------------------------------------------------------------------------
  # Bootstrap repo
  # ----------------------------------------------------------------------------

  # A systemd service that will automatically clone the repository on new
  # installations. The repository must be in place for all config files to
  # work (we use `mkOutOfStoreSymlink` for most of them).
  systemd.services.clone-repo = {
    description = "Clone ${repoName} repository if missing";
    wantedBy = [ "multi-user.target" ];
    before = [ "home-manager-${user}.service" ];
    # Skip if the repository is already in place
    unitConfig.ConditionPathExists = "!${repoDir}/.git";
    serviceConfig = {
      Type = "oneshot";
      User = "${user}";
      ExecStart = [
        # Systemd requires absolute paths to executables, it does not rely on $PATH.
        "${pkgs.git}/bin/git clone https://github.com/mabq/${repoName}.git ${repoDir}"
        "${pkgs.git}/bin/git -C ${repoDir} checkout ${repoBranch}"
      ];
    };
  };

  # ----------------------------------------------------------------------------
  # Nix
  # ----------------------------------------------------------------------------

  # Allow proprietary packages
  nixpkgs.config.allowUnfree = mkDefault true;

  nix = {
    # Use the latest version of the CLI
    package = mkDefault pkgs.nixVersions.latest;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = mkDefault true;
    };

    gc = {
      # Save disk space by automatically collection garbage
      #  https://nixos.org/manual/nixos/stable/#sec-nix-gc
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 15d";
    };
  };

  # ----------------------------------------------------------------------------
  # Boot (kernel)
  # ----------------------------------------------------------------------------

  # Use the latest stable Linux kernel available in Nixpkgs
  boot.kernelPackages = mkDefault pkgs.linuxPackages_latest;

  # ----------------------------------------------------------------------------
  # Memory
  # ----------------------------------------------------------------------------

  # Compress data in memory — minor CPU penalty in exchange of more capacity
  zramSwap = {
    enable = mkDefault true;
    memoryPercent = mkDefault 50;
    # Use `zstd` for higher compression rates on machines with capable CPUs
    algorithm = mkDefault "lz4";
    priority = 100; # prioritize zram over swap
  };

  # Swap — do this on host file when needed
  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

  # ----------------------------------------------------------------------------
  # Network
  # ----------------------------------------------------------------------------

  networking = {
    hostName = mkDefault host;
    firewall.enable = mkDefault true; # tailscale can go through
  };

  # ----------------------------------------------------------------------------
  # Time and locale
  # ----------------------------------------------------------------------------

  time.timeZone = mkDefault "America/Guayaquil";
  services.tzupdate.enable = mkDefault true; # update timezone automatically

  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  # ----------------------------------------------------------------------------
  # User accounts
  # ----------------------------------------------------------------------------

  users = {
    mutableUsers = mkDefault false; # no imperative changes
    users.${user} = {
      isNormalUser = mkDefault true;
      home = mkDefault "/home/${user}";
    };
  };

  # No password when escalating privileges for members of the `wheel` group
  security.sudo.wheelNeedsPassword = mkDefault false;

  # ----------------------------------------------------------------------------
  # Environment
  # ----------------------------------------------------------------------------

  # environment.systemPackages = with pkgs; [ ];

  # Environment variables
  #  These variables are pushed by NixOS to all shells (Bash, Zsh, etc.) and
  #  systemd user environment. Read more in "environment-variables"
  #  learning notes. Put here variables that you want available everywhere, for
  #  more specific variables use this option in the modules requiring them.
  #  Don't use `mkDefault` here
  environment.sessionVariables = {
    # These are used to avoid hard-coding paths in config files. Not all config
    # files accept environment variables though.
    MYNIX_REPO = "${repoDir}";
    MYNIX_THEME = "${localThemeDir}";

    # Include binaries of this repo in PATH. Don't use `<path>:$PATH` syntax here.
    PATH = "${repoDir}/bin";

    # Colorized man pages
    PAGER = "less -R --use-color -Dd+r -Du+b";
    MANPAGER = "less -R --use-color -Dd+r -Du+b";

    # Others
    MANROFFOPT = "-P -c"; # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
    # TERM = # do not set this variable, it is set by each terminal emulator.
  };

  # ----------------------------------------------------------------------------
  # Services
  # ----------------------------------------------------------------------------

  services = {
    tailscale = {
      enable = mkDefault true; # use `sudo tailscale up` to authenticate
      extraSetFlags = [
        # Flags like `--ssh` should be set on per-host basis
        # https://tailscale.com/docs/reference/tailscale-cli#set
        "--hostname=${config.networking.hostName}" # host module
      ];
    };

    openssh = {
      enable = mkDefault true;
      settings = {
        # Never allow root access!
        # Password authentication is disabled for improved security. Use ssh
        # keys or Tailscale SSH.
        PermitRootLogin = mkDefault "no";
        PasswordAuthentication = mkDefault false;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Home-manager
  # ----------------------------------------------------------------------------

  home-manager = {
    # Use the global `pkgs` that is configured via the system level nixpkgs
    # options. This saves an extra Nixpkgs evaluation, adds consistency, and
    # removes the dependency on `NIX_PATH`, which is otherwise used for
    # importing Nixpkgs.
    useGlobalPkgs = mkDefault true;
    # Install packages in `/etc/profiles` instead of `~/.nix-profile`.
    useUserPackages = mkDefault true;

    users.${user} =
      {
        osConfig, # https://nix-community.github.io/home-manager/installation/nixos.html#sec-install-nixos-module
        config,
        ...
      }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
        themeDir = lib.strings.removePrefix "/home/${user}" localThemeDir;
      in
      {
        home = {
          username = user;
          homeDirectory = "/home/${user}";
          stateVersion = osConfig.system.stateVersion;
          packages = with pkgs; [
            # -- Common packages for all configurations --
            age # Modern encryption tool with small explicit keys
            caligula # User-friendly, lightweight TUI for disk imaging
            exfatprogs # exFAT filesystem userspace utilities
            fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
            fzf # Command-line fuzzy finder
            just # Handy way to save and run project-specific commands
            pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
            psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
            ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
            sops # Simple and flexible tool for managing secrets
          ];

          # Create a symlink to the selected theme
          file."${themeDir}" = {
            source = mkOutOfStoreSymlink "${repoThemeDir}";
            force = true;
          };
        };
      };
  };
}
