{config, lib, pkgs, machine, ...}:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Use the latest stable linux kernel available in Nixpkgs
  boot.kernelPackages = pkgs.linuxPackages_latest; # (1)

  environment.systemPackages = with pkgs; [
    age
    gh
    git
    neovim
    yazi
    impala # TUI for managing wifi
  ];

  # i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  # Use the latest version of the `nix` CLI
  nix.package = lib.mkDefault pkgs.nixVersions.latest; # (2)

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Must enable default shell
  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.autosuggestions.enable = lib.mkDefault true;
  programs.zsh.syntaxHighlighting.enable = lib.mkDefault true;

  # Enable the OpenSSH daemon
  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PasswordAuthentication = lib.mkDefault true;
  services.openssh.settings.PermitRootLogin = lib.mkDefault "no";

  services.pipewire.enable = lib.mkDefault true;
  services.pipewire.pulse.enable = lib.mkDefault true;

  services.tailscale.enable = lib.mkDefault true; # (3)

  # Don't require password for sudo actions to wheel members
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  time.timeZone = lib.mkDefault "America/Guayaquil";

  # Virtualization settings
  virtualisation.docker.enable = lib.mkDefault true;

  # ----------------------------------------------------------------------------

  # --- Network DNS
  #     Use systemd-resolved to resolve DNS queries
  services.resolved = {
    enable = true;
    settings = {
      # Read `man 5 resolved.conf` for configuration files and options
      # These options afffect `/etc/systemd/resolved.conf`
      # Use `resolvectl <TAB>` to see all subcommands
      Resolve = {
        DNS = [
          # Use Cloudflare DNS servers
          "1.1.1.1" # IPv4
          "1.0.0.1" # IPv4 fallback
          "2606:4700:4700::1111" # IPv6
          "2606:4700:4700::1001" # IPv6 fallback
        ];
        FallbackDNS = [
          # Use Google DNS servers as fallback
          "8.8.8.8" # IPv4
          "8.8.4.4" # IPv4 fallback
          "2001:4860:4860::8888" # IPv6
          "2001:4860:4860::8844" # IPv6 fallback
        ];
        Domains = [ "~." ]; # use resolved for all domains
        DNSSEC = true; # DNS Security Extensions (cryptographic signing of DNS records to verify authenticity and integrity, preventing DNS spoofing, cache poisoning, and man-in-the-middle attacks) - fully supported by Cloudflare DNS servers.
        DNSOverTLS = true; # Encrypt DNS queries between your device and the DNS resolver using TLS (port 853), preventing eavesdropping, tampering, and ISP snooping - fully supported by Cloudflare DNS servers
      };
    };
  };

  # Networkd handles DHCP now (must be turned off, is on by default)
  networking.useDHCP = lib.mkDefault false;

  # Enable systemd-networkd
  systemd.network = {
    enable = true;
    networks = {
      # The key is the .network filename in `/etc/systemd/network`; match order matters (lower = higher priority)
      "10-ethernet" = {
        matchConfig = {
          Name = "en* eth*"; # matches enp3s0, eno1, etc.
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
        networkConfig = {
          DHCP = "yes";
          # MulticastDNS = "yes";
        };
        dhcpV4Config = {
          RouteMetric = 100; # prefer wired over wireless
          UseDNS = false;
          UseDomains = false;
        };
        dhcpV6Config = {
          RouteMetric = 100; # prefer wired over wireless
          UseDNS = false;
          UseDomains = false;
        };
      };
      # "10-ethernet-static" = {
      #   matchConfig = {
      #     Name = "en* eth*"; # matches enp3s0, eno1, etc.
      #   };
      #   networkConfig = {
      #     Address = "192.168.1.50/24";
      #     Gateway = "192.168.1.1";
      #   };
      # };
      "20-wlan" = {
        matchConfig = {
          Name = "wl*";
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
        networkConfig = {
          DHCP = "yes";
          # MulticastDNS = "yes";
        };
        dhcpV4Config = {
          RouteMetric = 600;
          UseDNS = false;
          UseDomains = false;
        };
        dhcpV6Config = {
          RouteMetric = 600;
          UseDNS = false;
          UseDomains = false;
        };
      };
      "30-wwan" = {
        matchConfig = {
          Name = "ww*";
        };
        linkConfig = {
          RequiredForOnline = "routable";
        };
        networkConfig = {
          DHCP = "yes";
        };
        dhcpV4Config = {
          RouteMetric = 700;
          UseDNS = false;
          UseDomains = false;
        };
        dhcpV6Config = {
          RouteMetric = 700;
          UseDNS = false;
          UseDomains = false;
        };
      };
    };
  };

  # Enable iwd (Internet wireless daemon)
  # Tools like systemd-networkd only configure IP networking (DHCP, addresses, routes). They do not handle Wi-Fi authentication.
  # Required by impala for wifi authentication
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.EnableNetworkConfiguration = false;  # let networkd handle IPs
      Network.EnableIPv6 = true;
    };
  }; 

  networking.hostName = lib.mkDefault "${machine}";

}

# -----------------------------------------------------------------------------
# (1)
# [Hashimoto](https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L11)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/#sec-kernel-config)
# -----------------------------------------------------------------------------
# (2)
# [Hashimoto](https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L14)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/#sec-kernel-config)
# -----------------------------------------------------------------------------
# (3)
# Manually authenticate with `sudo tailscale up`.
# -----------------------------------------------------------------------------
