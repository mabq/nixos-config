# This file is for system-level configs only. For user-level configs use
# home-manager.
#
# Use `mkDefault` to allow per-host config files to override any configuration
# option set here.

{ config, lib, pkgs, machine, ... }:
with lib; {

  # ----------------------------------------------------------------------------
  # Nixpkgs and Nix CLI config
  # ----------------------------------------------------------------------------

  # Allow proprietary packages by default
  nixpkgs.config.allowUnfree = mkDefault true;

  # Nix cli config
  nix = {
    package = mkDefault pkgs.nixVersions.latest; # use the latest version of the cli

    settings = {
      experimental-features = ["nix-command" "flakes"]; # enable flake support
      auto-optimise-store = mkDefault true;
    };

    gc = {
      automatic = mkDefault true; # save disk space by automatically collection garbage
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 15d";
    };
  };

  # ----------------------------------------------------------------------------
  # Boot options
  # ----------------------------------------------------------------------------

  boot = {
    # Use the latest stable linux kernel available in Nixpkgs [1]
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    # Limit the number of generations to keep
    loader = {
      systemd-boot.configurationLimit = mkIf config.boot.loader.systemd-boot.enable (mkDefault 10);
      grub.configurationLimit = mkIf config.boot.loader.grub.enable (mkDefault 10);
    };
  };

  # ----------------------------------------------------------------------------
  # Swap and Zram
  # ----------------------------------------------------------------------------

  # Use this on per-host config file to setup swap when needed
  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

  # Memory compression allows you to put more data into memory without affecting performance
  zramSwap = {
    enable = mkDefault true;
    memoryPercent = mkDefault 50;
    algorithm = mkDefault "lz4"; # On machines with newer CPUs use `zstd` for higher compression rates.
    priority = 100; # Use zram before swap file
  };

  # ----------------------------------------------------------------------------
  # Hardware
  # ----------------------------------------------------------------------------

  hardware = {
    facter = {
      reportPath = ./${machine}/facter.json; # configure hardware based on facter report
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
  # System packages and services
  # ----------------------------------------------------------------------------

  environment = {
    systemPackages = with pkgs; [
      gh # GitHub CLI tool (required to clone private repos without ssh key)
      git # Distributed version control system
      just # Handy way to save and run project-specific commands
    ];
  };

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
  # System config
  # ----------------------------------------------------------------------------

  # User accounts configs
  security.sudo.wheelNeedsPassword = mkDefault false; # no sudo password for users who are members of `wheel`
  users.mutableUsers = mkDefault false; # no imperative changes of user accounts

  # Timezone and locale
  time.timeZone = mkDefault "America/Guayaquil";

  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
    # extraLocales = mkDefault ["es_EC.UTF-8"];
  };

  # Basic network stuff
  networking = {
    hostName = mkDefault machine;
    firewall.enable = mkDefault true; # No need to open any ports when using Tailscale
  };
}
