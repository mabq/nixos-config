# Import this module to use DHCP with systemd-networkd and custom DNS servers.
{
  lib,
  pkgs,
  user,
  ...
}:
with lib;
{
  # ----------------------------------------------------------------------------
  # Disable conflicting options
  #  These options are enabled by default and must be disabled to avoid
  #  conflicts with networkd and resolved.
  # ----------------------------------------------------------------------------

  # Each network interface should be managed by only one DHCP client or network
  # manager. Disable default NixOS script-based DHCP configuration on all
  # interfaces since networkd has its own built-in DHCP client daemon.
  networking.useDHCP = false;

  # Disable facter network configurations.
  hardware.facter.detected.dhcp.enable = false;

  # Disable default resolveconf in favor of systemd-resolved [4]
  networking.resolvconf.enable = mkDefault false;

  # ----------------------------------------------------------------------------
  # Systemd-networkd
  #  https://nixos.wiki/wiki/Systemd-networkd
  # ----------------------------------------------------------------------------

  # This option is a compatibility mechanism which translates older
  # `networking.*` options into networkd configurations. Since we are using
  # native `systemd.network.networks` declarations, it's unnecessary.
  # `networking.useNetworkd = true;`

  # Increase log details for possible debugging.
  #  https://nixos.wiki/wiki/Systemd-networkd#Debugging
  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  # systemd-networkd configuration.
  systemd.network = {
    enable = mkDefault true;

    # Consider the system "online" when any interface reaches "routable" state.
    wait-online.anyInterface = mkDefault true;

    # Configure network interfaces [1]
    #  https://wiki.archlinux.org/title/Network_configuration#Network_interfaces
    #  Virtual interfaces like `wg0` or `tailscale0` do not need to be configured.
    networks = {
      # Configurations for ethernet connections (highest priority)
      "10-ether" = {
        # The first file matching the interface name will be used. Files are
        # scanned in alpha-numeric order, the lower the number prefix the higher
        # the priority [2].
        #
        # Matching with `Type=ether` causes issues with containers because it
        # also matches virtual Ethernet interfaces like `veth*` [3]. Better
        # match by globbing the network interface name.
        matchConfig.Name = mkDefault "en* eth*";

        # Prevent `systemd-networkd-wait-online.service` (enabled by default)
        # from exiting before network interfaces have a routable IP address
        # and thus having other services that require a working network
        # connection starting too early.
        linkConfig.RequiredForOnline = mkDefault "routable";

        networkConfig = {
          # Use DHCP — for static example see [5]
          DHCP = mkDefault "yes";

          # Accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
          IPv6AcceptRA = mkDefault true;

          # Systemd-resolved supports per-link DNS configuration. Don't use the
          # DNS servers of this link (if any) for general/global queries (only
          # for domains you've explicitly routed to it via `Domains=`).
          DNSDefaultRoute = mkDefault false;
          # Domains = ;

          # Disable MulticastDNS to improve security
          MulticastDNS = mkDefault "no";
        };
        dhcpV4Config = {
          # Ignore the DNS servers obtained from the DHCP server. We want all
          # queries to use the Global DNS settings defined below.
          UseDNS = mkDefault false;
          # Prefer wired connections — lower values take precedence.
          RouteMetric = mkDefault 100;
        };
        dhcpV6Config = {
          UseDNS = mkDefault false;
          # There is no `RouteMetric` option in this section.
        };
        ipv6AcceptRAConfig = {
          UseDNS = mkDefault false;
          RouteMetric = mkDefault 100;
        };
      };

      # Configurations for wireless connections (less priority)
      "20-wlan" = {
        matchConfig.Name = mkDefault "wl*";
        linkConfig.RequiredForOnline = mkDefault "routable";
        networkConfig = {
          DHCP = mkDefault "yes";
          IPv6AcceptRA = mkDefault true;
          DNSDefaultRoute = false;
          # Domains = ;
          MulticastDNS = mkDefault "no";
        };
        dhcpV4Config = {
          UseDNS = mkDefault false;
          RouteMetric = mkDefault 600; # Lower priority than ethernet
        };
        dhcpV6Config = {
          UseDNS = mkDefault false;
          # There is no `RouteMetric` option in this section.
        };
        ipv6AcceptRAConfig = {
          UseDNS = mkDefault false;
          RouteMetric = mkDefault 600;
        };
      };
    };
  };

  # [1] https://wiki.archlinux.org/title/Network_configuration#Network_interfaces
  #     https://man.archlinux.org/man/systemd.network.5
  #     https://wiki.archlinux.org/title/Systemd-networkd
  # [2] https://man.archlinux.org/man/systemd.network.5#%5BMATCH%5D_SECTION_OPTIONS
  #     https://systemd.io/PREDICTABLE_INTERFACE_NAMES/
  # [3] See https://bugs.archlinux.org/task/70892
  # [4] https://tailscale.com/blog/sisyphean-dns-client-linux
  # [5] https://nixos.wiki/wiki/Systemd-networkd#Static

  # ----------------------------------------------------------------------------
  # Configure systemd-resolved (DNS)
  #  https://nixos.wiki/wiki/Systemd-resolved
  # ----------------------------------------------------------------------------

  services.resolved = {
    enable = mkDefault true;

    settings.Resolve = {
      # Make Quad9 DNS servers the default option
      DNS = mkDefault [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];

      # Use CloudFlare DNS servers as fallback
      FallbackDNS = mkDefault [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];

      # Make the Global interface the default for all DNS queries that do not
      # match any more specific routing domain on other interfaces [1].
      # This does not affect queries of domain names that match the more
      # specific search domains specified in per-link configuration, they will
      # still be resolved using their respective per-link DNS servers.
      Domains = mkDefault [ "~." ];

      # Encrypt DNS queries whenever possible [2]. Fallback to unencrypted
      # queries if the DNS server does not support it to avoid DNS resolution
      # failure.
      #
      # To verify that DNS over TLS is being used run `ngrep port 853`, it
      # should produce encrypted output. On the other hand `ngrep port 53`
      # should produce no output at all.
      DNSOverTLS = mkDefault "opportunistic";

      # Verify DNS signatures whenever possible [3]. This totally depends on
      # the domains being queried, allow downgrade to allow access to
      # real-world sites (old or small sites) that do not have this enabled.
      DNSSEC = mkDefault "allow-downgrade";

      # Enable zero-configuration local name resolution [4]. Common for
      # discovering printers, Chromecast, AirPlay, smart devices. Implemented
      # by Avahi (Linux) or Bonjour (Apple).
      MulticastDNS = mkDefault true;
    };
  };

  # [1] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#Domains=
  # [2] https://wiki.archlinux.org/title/Systemd-resolved#DNS_over_TLS
  #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSOverTLS=
  # [3] https://wiki.archlinux.org/title/Systemd-resolved#DNSSEC
  #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSSEC=
  # [4] https://wiki.archlinux.org/title/Systemd-resolved#mDNS
  #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#MulticastDNS=

  # ----------------------------------------------------------------------------
  # Wi-Fi tools
  # ----------------------------------------------------------------------------

  # Iwd brings the wireless link up (scans, authenticates, associates).
  # Systemd-networkd configures IP/DNS after iwd has brought the link up [1].
  networking.wireless.iwd.enable = mkDefault true;

  # The user must be a member of the `wheel` group to manage iwd [2]
  users.users.${user}.extraGroups = [ "wheel" ];

  # Some required packages
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      impala # TUI for managing wifi
      dig # Domain name server (provides the `nslookup` command to check DNS)
    ];
  };

  # [1] https://wiki.archlinux.org/title/Iwd
  # [2] https://wiki.archlinux.org/title/Iwd#Usage
  # [3] https://wiki.archlinux.org/title/Iwd#Installation
}

/*
  Systemd-networkd is ligher than NetworkManager but has less features — see
  https://nixos.wiki/wiki/Systemd-networkd#When_to_use.

  It does not run background processes - e.g. it won't automatically switch to
  another Wi-Fi network, you need to do that manually.

  It lacks the ability to automatically open "login pages" when connecting to
  public networks using captive portals - you need to trigger those manually.
  Run `networkctl status <wlan>` and look for the "Captive Portal" field,
  then manually open the portal in your browser using the URL shown, or try
  accessing `http://neverssl.com` or `http://captive.apple.com` to trigger the
  redirect.

  ---

  Systemd-networkd is configured declaratively - perfect for Nixos management.

  `networkctl` [1] is primarily used to query network configuration, the few
  state changes you will ever do with it are added to "drop-in" files that do
  not affect the main `.network` files [2].

  Changes in "drop-in" files are invisible to NixOS, hence not reproducible.

  [1] https://man.archlinux.org/man/networkctl.1.en
  [2] https://man.archlinux.org/man/systemd.network.5#DESCRIPTION

  ---

  Systemd-networkd offers full integration with systemd-resolved.

  Systemd-networkd configurations [1] take precedence over systemd-resolved
  configurations [2]. This allows you to set per-link configurations. Thats why
  we instruct systemd-networkd to ignore the DNS Servers received from the DHCP.

  [1] https://man.archlinux.org/man/systemd.network.5
  [2] https://man.archlinux.org/man/resolved.conf.5

  ---

  systemd-resolved [1] provides a DNS stub listener in 127.0.0.53 that caches
  resolved queries to make subsequent queries much faster.

  You can change global DNS servers at runtime by executing
  `sudo resolvectl dns <interface> <DNS IP>`. To undo the changes just
  restart the systemd-networkd service.

  Use `resolvectl status` to check DNS servers being currently used.

  [1] https://wiki.archlinux.org/title/Systemd-resolved

  ---

  To enforce DNS servers defined in Tailscale Admin Console, comment the line
      Domains = mkDefault [ "~." ];
  in systemd-resolved configuration. Make sure you check the override DNS servers
  option in Tailscale [1].

  [1] https://tailscale.com/docs/reference/dns-in-tailscale?tab=linux#override-dns-servers
  [2] https://tailscale.com/docs/reference/tailscale-cli#up
*/
