# Tips:
#   See `man configuration.nix` and `nixos-help`.
#   In "MyNixOs" website search: `<program> nixpkgs/option` for system configuration options.

{ config, pkgs, lib, c, ... }: {

  boot = {
    # Use the systemd-boot EFI boot loader (most common, can be overwritten by specific hardware files)
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Use the latest Linux kernel - be careful updating this.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix = {
    # Enable flakes
    settings.experimental-features = "nix-command flakes";

    # Use the latest possible version of nix provided by the version of the flake
    package = pkgs.nixVersions.latest;
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault c.system;

    # Allow propietary packages?
    config.allowUnfree = c.pkgsAllowUnfree;

    # List of allowed insecure packages
    config.permittedInsecurePackages = c.pkgsInsecure;
  };

  networking = {
    hostName = c.hostname;

    # Enable network manager
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    useDHCP = false;

    # Set firewall and open ports (22 ssh, 53317 localsend)
    # ⚠️ open ports in their own modules
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 53317 ];
      allowedUDPPorts = [ 22 53317 ];
    };
  };

  # Set your time zone.
  time.timeZone = c.timezone;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = c.locale;
    extraLocaleSettings = {
      LC_ADDRESS = "es_EC.UTF-8";
      LC_IDENTIFICATION = "es_EC.UTF-8";
      LC_MEASUREMENT = "es_EC.UTF-8";
      LC_MONETARY = "es_EC.UTF-8";
      LC_NAME = "es_EC.UTF-8";
      LC_NUMERIC = "es_EC.UTF-8";
      LC_PAPER = "es_EC.UTF-8";
      LC_TELEPHONE = "es_EC.UTF-8";
      LC_TIME = "es_EC.UTF-8";
    };
  };

  # Replace user and group files on system activation. Don't forget to set the password with `passwd`.
  # users.mutableUsers = false;

  # Manage fonts. We pull these from a secret directory since most of these fonts require a purchase.
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [ fira-code jetbrains-mono ];
  };

  # System packages
  environment.environment.systemPackages = with pkgs; [ ];

  services = {
    openssh = {
      # ⚠️ Move to its own module
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "no";
    };

    # Enable flatpak. I don't use any flatpak apps but I do sometimes
    # test them so I keep this enabled.
    # ⚠️ Move to its own module
    flatpak.enable = true;

    # Enable snap. I don't really use snap but I do sometimes test them
    # and release snaps so we keep this enabled.
    # ⚠️ Move to its own module
    snap.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘c perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
