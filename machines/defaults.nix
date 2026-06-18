# This file only contains default system-level configs.
# These are default values (`mkDefault`), you can override them in per-host configuration files.

{
  lib,
  pkgs,
  machine,
  ...
}:
with lib;
{
  # ----------------------------------------------------------------------------
  # Boot (kernel)
  # ----------------------------------------------------------------------------

  boot = {
    # Use the latest stable linux kernel available in Nixpkgs
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    # Limit the number of generations to keep in the boot loader
    # loader = {
    #   systemd-boot.configurationLimit = mkIf config.boot.loader.systemd-boot.enable (mkDefault 10);
    #   grub.configurationLimit = mkIf config.boot.loader.grub.enable (mkDefault 10);
    # };
  };

  # ----------------------------------------------------------------------------
  # Hardware
  # ----------------------------------------------------------------------------

  hardware = {
    facter = {
      reportPath = ./facter/${machine}.json; # configure hardware based on facter report
    };

    bluetooth = {
      enable = mkDefault true;
      powerOnBoot = mkDefault true; # ensure Bluetooth is powered on after reboot
      settings = {
        General = {
          Experimental = mkDefault true; # required for some newer codecs like LDAC
          FastConnectable = mkDefault true; # for faster connections (may increase power usage)
        };
        Policy = {
          AutoEnable = mkDefault true; # automatically enable all controllers when found
        };
      };
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

  # Swap (better use this on per-machine file as needed)
  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

  # ----------------------------------------------------------------------------
  # System packages
  # ----------------------------------------------------------------------------

  environment = {
    systemPackages = with pkgs; [
      # TODO: move these packages to home-manger
      gh # GitHub CLI tool (required to clone private repos without ssh key)
      git # Distributed version control system
      just # Handy way to save and run project-specific commands
    ];
  };

  # ----------------------------------------------------------------------------
  # System services
  # ----------------------------------------------------------------------------

  services = {
    openssh = {
      enable = mkDefault true; # in case you ever lose Tailscale access
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = mkDefault "no";
      };
    };

    tailscale.enable = mkDefault true; # must authenticate manually with `sudo tailscale up`

    tzupdate.enable = mkDefault true; # update timezone automatically
  };

  # ----------------------------------------------------------------------------
  # Network
  # ----------------------------------------------------------------------------

  networking = {
    hostName = mkDefault machine;
    firewall.enable = mkDefault true; # tailscale can go through
  };

  # ----------------------------------------------------------------------------
  # User accounts
  # ----------------------------------------------------------------------------

  users.mutableUsers = mkDefault false; # no imperative changes of user accounts
  security.sudo.wheelNeedsPassword = mkDefault false; # no sudo password for users who are members of `wheel`

  # ----------------------------------------------------------------------------
  # Time and locale
  # ----------------------------------------------------------------------------

  time.timeZone = mkDefault "America/Guayaquil";

  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
  };

  # ----------------------------------------------------------------------------
  # Nixpkgs
  # ----------------------------------------------------------------------------

  nixpkgs.config.allowUnfree = mkDefault true; # allow proprietary packages by default

  # ----------------------------------------------------------------------------
  # Nix CLI
  # ----------------------------------------------------------------------------

  nix = {
    package = mkDefault pkgs.nixVersions.latest; # use the latest version of the cli

    settings = {
      # Enable flake support
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = mkDefault true;
    };

    gc = {
      # Save disk space by automatically collection garbage
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 15d";
    };
  };
}
