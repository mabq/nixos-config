# Don't forget to use `mkDefault`, these should be overidable.
{
  inputs,
  config,
  lib,
  pkgs,
  host,
  user,
  stateVersion,
  theme,
  repoDir,
  themeDir,
  ...
}:
with lib;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

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
    algorithm = mkDefault "lz4"; # use `zstd` for higher compression rates on newer cpus
    priority = 100; # prioritize zram over swap
  };

  # Swap — do this on host file when needed
  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

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

  # ----------------------------------------------------------------------------
  # Home-manager
  # ----------------------------------------------------------------------------

  home-manager = {
    # Integrate home-manager with NixOS:
    #   User binaries in `/etc/profiles/per-user/<username>/bin` (not `~/.nix-profile/bin`)
    #   Single command to collect all garbage: `nix-collect-garbage -d`
    #   Single command to rebuild both: `nixos-rebuild`
    # These options should only be set to `false` when using `nix` in non-NixOS
    # linux distributions (like Ubuntu/Arch).
    useGlobalPkgs = mkDefault true;
    useUserPackages = mkDefault true;

    # Common user configurations
    users.${user} =
      { config, ... }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
        currentThemeDir = lib.strings.removePrefix "/home/${user}" themeDir;
      in
      {
        home = {
          username = mkDefault user;
          homeDirectory = mkDefault "/home/${user}";
          stateVersion = mkDefault stateVersion; # See notes at the bottom

          # Packages available to all users/profiles
          packages = with pkgs; [
            age # Modern encryption tool with small explicit keys
            just # Handy way to save and run project-specific commands
            sops # Simple and flexible tool for managing secrets
          ];

          # Symlink current theme
          file."${currentThemeDir}" = {
            source = mkOutOfStoreSymlink "${repoDir}/themes/${theme}";
            force = true;
          };
        };

      };

  };

  # ----------------------------------------------------------------------------
  # Security
  # ----------------------------------------------------------------------------

  # No password when escalating privileges for members of the `wheel` group.
  security.sudo.wheelNeedsPassword = mkDefault false;

  # ----------------------------------------------------------------------------
  # System packages
  # ----------------------------------------------------------------------------

  # environment.systemPackages = with pkgs; [ ];

  # ----------------------------------------------------------------------------
  # Environment variables
  # ----------------------------------------------------------------------------
  #
  # NixOS takes static variables defined in this option and writes them into
  # `/etc/set-environment`. Then it automatically:
  #
  #   Makes them available to all interactive and non-interactive shells for
  #   Bash, Zsh, Fish, etc. For example, review `/etc/zshenv` to see how it is
  #   configured to source `/etc/set-environment`. To learn more read notes in
  #   the zsh module.
  #
  #   Pushes them to the newly spawned `systemd --user` instance via
  #   `systemctl --user import-environment`. Note that NixOS cannot push to
  #   systemd variables set after login (e.g. variables set by Hyprland). For
  #   those see notes in uwsm module.
  #
  # Only put here variables that you want available everywhere. Otherwise use
  # this option in specific modules (e.g. neovim, hyprland, etc.). Do a live
  # grep to check where it is being used.

  environment.sessionVariables = {
    REPODIR = "${repoDir}"; # avoid hard-coding the repo directory in most config files
    THEMEDIR = "${themeDir}"; # avoid hard-coding the theme dir in most config files

    PATH = "${repoDir}/bin"; # include binaries of this repo in PATH (don't use `<path>:$PATH` syntax here)

    PAGER = "less -R --use-color -Dd+r -Du+b"; # colorized pager
    MANPAGER = "less -R --use-color -Dd+r -Du+b"; # colorized man pages
    MANROFFOPT = "-P -c"; # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
    # TERM = # do not set this variable, it is set by each terminal emulator.
  };

  # ----------------------------------------------------------------------------
  # Services
  # ----------------------------------------------------------------------------

  services = {
    tailscale = {
      enable = mkDefault true; # auth manually or via an auth key in profile file
      extraSetFlags = [
        # https://tailscale.com/docs/reference/tailscale-cli#set
        "--hostname=${config.networking.hostName}"
      ];
    };

    openssh = {
      enable = mkDefault true;
      settings = {
        PermitRootLogin = mkDefault "no"; # never!!
        PasswordAuthentication = mkDefault false; # use ssh keys or Tailscale SSH instead
      };
    };

    tzupdate.enable = mkDefault true; # update timezone automatically
  };

  # ----------------------------------------------------------------------------
  # Network
  # ----------------------------------------------------------------------------

  networking = {
    hostName = mkDefault host; # override on host file
    firewall.enable = mkDefault true; # tailscale can go through
  };

  # ----------------------------------------------------------------------------
  # Time and locale
  # ----------------------------------------------------------------------------

  time.timeZone = mkDefault "America/Guayaquil"; # override in host file

  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
  };

  # ----------------------------------------------------------------------------
  # Nixpkgs
  # ----------------------------------------------------------------------------

  nixpkgs.config.allowUnfree = mkDefault true; # allow proprietary packages

  # ----------------------------------------------------------------------------
  # Nix CLI
  # ----------------------------------------------------------------------------

  nix = {
    package = mkDefault pkgs.nixVersions.latest; # latest cli version

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
  # System
  # ----------------------------------------------------------------------------

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = stateVersion; # Did you read the comment?
}
