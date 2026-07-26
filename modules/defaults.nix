# These are used as defaults for all systems — use `mkDefault`!
{
  config,
  lib,
  pkgs,
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

  boot = {
    # Use the latest stable linux kernel available in Nixpkgs
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    # Limit the number of generations to keep in the boot loader
    loader = {
      systemd-boot.configurationLimit = mkIf config.boot.loader.systemd-boot.enable (mkDefault 10);
      grub.configurationLimit = mkIf config.boot.loader.grub.enable (mkDefault 10);
    };
  };

  # ----------------------------------------------------------------------------
  # Memory
  # ----------------------------------------------------------------------------

  # Compress data in ram (no major performance penalty)
  zramSwap = {
    enable = mkDefault true;
    memoryPercent = mkDefault 50;
    algorithm = mkDefault "lz4"; # on capable CPUs use `zstd` for higher compression rates
    priority = 100; # prioritize zram over swap
  };

  # Swap (use this on per-machine file as needed)
  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

  # ----------------------------------------------------------------------------
  # User accounts
  # ----------------------------------------------------------------------------

  users = {
    mutableUsers = mkDefault false; # do not allow imperative changes of user accounts
    users.${user} = {
      isNormalUser = mkDefault true;
      home = mkDefault "/home/${user}";
    };
  };

  # ----------------------------------------------------------------------------
  # Home-manager
  # ----------------------------------------------------------------------------

  home-manager = {
    # Make home-manager integrate deeply with NixOS, e.g.:
    #  `/etc/profiles/per-user/<username>/bin` instead of `~/.nix-profile/bin`.
    #  `nix-collect-garbage -d` collects garbage from both.
    #  `nixos-rebuild` rebuilds both.
    # These options should only be set to `false` when using `nix` in non-NixOS
    # Linux distributions (like Ubuntu/Arch).
    useGlobalPkgs = mkDefault true;
    useUserPackages = mkDefault true;
    users.${user}.home = {
      username = mkDefault user;
      homeDirectory = mkDefault "/home/${user}";
      stateVersion = mkDefault stateVersion; # see notes at the bottom
    };
  };

  # ----------------------------------------------------------------------------
  # Security
  # ----------------------------------------------------------------------------

  security.sudo.wheelNeedsPassword = mkDefault false; # no sudo password for users who are members of `wheel`

  # ----------------------------------------------------------------------------
  # System packages
  # ----------------------------------------------------------------------------

  environment = {
    systemPackages = with pkgs; [ ];
  };

  # ----------------------------------------------------------------------------
  # OpenSSH and Tailscale
  # ----------------------------------------------------------------------------

  services = {
    tailscale.enable = mkDefault true; # authenticate with `sudo tailscale up`

    openssh = {
      enable = mkDefault true;
      settings = {
        PasswordAuthentication = mkDefault false; # ssh keys or Tailscale only!
        PermitRootLogin = mkDefault "no"; # never!
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Network
  # ----------------------------------------------------------------------------

  networking = {
    hostName = mkDefault "nixos"; # override on host file
    firewall.enable = mkDefault true; # tailscale can go through
  };

  # ----------------------------------------------------------------------------
  # Time and locale
  # ----------------------------------------------------------------------------

  time.timeZone = mkDefault "America/Guayaquil"; # override in host file
  services.tzupdate.enable = mkDefault true; # update timezone automatically

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
