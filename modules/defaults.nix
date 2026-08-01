# These are used as defaults for all systems — use `mkDefault`!
{
  inputs,
  lib,
  pkgs,
  host,
  user,
  stateVersion,
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
    #  User binaries in `/etc/profiles/per-user/<username>/bin` (not `~/.nix-profile/bin`)
    #  Single command to collect all garbage: `nix-collect-garbage -d`
    #  Single command to rebuild both: `nixos-rebuild`
    # These options should only be set to `false` when using `nix` in non-NixOS
    # Linux distributions (like Ubuntu/Arch).
    useGlobalPkgs = mkDefault true;
    useUserPackages = mkDefault true;
    users.${user}.home = {
      username = mkDefault user;
      homeDirectory = mkDefault "/home/${user}";
      packages = with pkgs; [
        # Required by all configurations
        just # Handy way to save and run project-specific commands
        age # Modern encryption tool with small explicit keys
        sops # Simple and flexible tool for managing secrets
      ];
      stateVersion = mkDefault stateVersion; # see notes at the bottom
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

  environment = {
    systemPackages = with pkgs; [ ];
  };

  # ----------------------------------------------------------------------------
  # Services
  # ----------------------------------------------------------------------------

  services = {
    tailscale.enable = mkDefault true; # auth manually or in user's config file

    openssh = {
      enable = mkDefault true;
      settings = {
        PermitRootLogin = mkDefault "no"; # Never!
        PasswordAuthentication = mkDefault false; # Auth via SSH keys or Tailscale SSH
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
