# This file should only include system level stuff. User level stuff should be managed by home-manager.
# You can disable anything enabled here in each machine configuration file.
{
  config,
  lib,
  pkgs,
  machine,
  ...
}:
with lib; {
  boot = {
    # Use the latest stable linux kernel available in Nixpkgs [1]
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    loader = {
      # Limit the number of generations to keep
      systemd-boot.configurationLimit = mkIf config.boot.loader.systemd-boot.enable (mkDefault 10);
      grub.configurationLimit = mkIf config.boot.loader.grub.enable (mkDefault 10);
    };
  };

  hardware.bluetooth = {
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

  environment = {
    systemPackages = with pkgs; [
      gh # GitHub CLI tool (required for authentication)
      git # Distributed version control system
      just # Handy way to save and run project-specific commands
    ];
  };

  hardware.facter.reportPath = ./${machine}/facter.json;

  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
    # extraLocales = mkDefault ["es_EC.UTF-8"];
  };

  networking = {
    hostName = mkDefault machine;
    firewall.enable = mkDefault true;
  };

  nix = {
    # Use the latest version of the nix command
    package = mkDefault pkgs.nixVersions.latest;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = mkDefault true;
    };
    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 15d";
    };
  };

  nixpkgs.config.allowUnfree = mkDefault true;

  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

  # No sudo password for members of `wheel`
  security.sudo.wheelNeedsPassword = mkDefault false;

  services = {
    # Enable the OpenSSH daemon (in case you ever lose Tailscale access)
    openssh = {
      enable = mkDefault true;
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = mkDefault "no";
      };
    };

    # Enable Tailscale - must authenticate manually `sudo tailscale up`
    tailscale.enable = mkDefault true;

    # Update timezone automatically
    tzupdate.enable = mkDefault true;
  };

  time.timeZone = mkDefault "America/Guayaquil";

  # No imperative changes of user accounts.
  users.mutableUsers = mkDefault false;

  zramSwap = {
    enable = mkDefault true;
    memoryPercent = mkDefault 50;
    algorithm = mkDefault "lz4"; # On machines with newer CPUs use `zstd` for higher compression rates.
    priority = 100; # Use zram before swap file
  };
}
