# Don't forget to use `mkDefault`, these should be overidable.
{
  config,
  lib,
  pkgs,
  host,
  user,
  theme,
  branch,
  repoName,
  repoDir,
  currentThemeDir,
  ...
}:
with lib;
{
  # ----------------------------------------------------------------------------
  # Bootstrap repo
  # ----------------------------------------------------------------------------

  systemd.services.clone-repo = {
    description = "Clone ${repoName} repository if missing";
    wantedBy = [ "multi-user.target" ];
    before = [ "home-manager-${user}.service" ];
    # Skip if the repo is already in place
    unitConfig.ConditionPathExists = "!${repoDir}/.git";
    serviceConfig = {
      Type = "oneshot";
      User = "${user}";
      ExecStart = [
        "${pkgs.git}/bin/git clone https://github.com/mabq/${repoName}.git ${repoDir}"
        "${pkgs.git}/bin/git -C ${repoDir} checkout ${branch}"
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
  # Network
  # ----------------------------------------------------------------------------

  networking = {
    hostname = mkDefault host;
    firewall.enable = mkDefault true; # tailscale can go through
  };

  # ----------------------------------------------------------------------------
  # Time and locale
  # ----------------------------------------------------------------------------

  time.timeZone = mkDefault "America/Guayaquil";
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
    MYNIX_THEME = "${currentThemeDir}";

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
      # This only enables the service, you must activate manually with
      # `sudo tailscale up` and authenticate via a web browser.
      # Flags allowing ssh access and more should be set on per-host basis.
      enable = mkDefault true;
      extraSetFlags = [
        # https://tailscale.com/docs/reference/tailscale-cli#set
        "--hostname=${config.networking.hostName}" # host module
      ];
    };

    openssh = {
      enable = mkDefault true;
      settings = {
        # Do not allow root access or password authentication for improved
        # security. Use ssh keys or Tailscale ssh.
        PermitRootLogin = mkDefault "no";
        PasswordAuthentication = mkDefault false;
      };
    };

    # Update timezone automatically
    tzupdate.enable = mkDefault true;
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

    users.${user} =
      { config, ... }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
        _currentThemeDir = lib.strings.removePrefix "/home/${user}" currentThemeDir;
      in
      {
        home = {
          username = user;
          homeDirectory = "/home/${user}";
          stateVersion = config.system.stateVersion;
          packages = with pkgs; [
            age # Modern encryption tool with small explicit keys
            caligula # User-friendly, lightweight TUI for disk imaging
            fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
            just # Handy way to save and run project-specific commands
            pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
            psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
            sops # Simple and flexible tool for managing secrets
          ];

          # Symlink current theme
          file."${_currentThemeDir}" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/${repoName}/themes/${theme}";
            force = true;
          };
        };
      };
  };
}
