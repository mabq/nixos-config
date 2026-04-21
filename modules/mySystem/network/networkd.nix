{ config, lib, pkgs, user, ... }:

with lib;

{
  options.mySystem.network.networkd.enable = mkEnableOption "Use systemd-networkd as the network manager";

  config = mkIf config.mySystem.network.networkd.enable {
    # # Make sure NetworkManager is disabled
    # mySystem.network.networkmanager.enable = mkForce false;

    # Do not create DHCP configurations based on facter file
    hardware.facter.detected.dhcp.enable = mkDefault false;

    # -------------------------------------------------------------------------
    # systemd-networkd
    # -------------------------------------------------------------------------

    # Disable conflicting services - these are enabled by default and conflict
    # with systemd-networkd.
    networking.useDHCP = false;
    networking.dhcpcd.enable = false;

    # Enable and configure systemd-networkd
    systemd.network = {
      enable = true;

      # Consider the system "online" when any interface reaches "routable" state
      wait-online.anyInterface = true;

      # Create `.network` configuration files [1] - only for hardware
      # interfaces, virtual interfaces like `wg0` or `tailscale0` are managed
      # directly by those programs.
      networks = {
        "10-ether" = {
          matchConfig = {
            # The `[MATCH]` section determines which file is used to configure
            # each interface. Only the first one to match is used - that is the
            # reason for numbered prefix [2].
            #
            # Matching with `Type=ether` causes issues with containers because it
            # also matches virtual Ethernet interfaces (`veth*`) [3].
            # Instead match by globbing the network interface name.
            Name = "en* eth*";
          };
          linkConfig = {
            # Prevent `systemd-networkd-wait-online.service` (enabled by default)
            # from exiting before network interfaces have a routable IP address
            # (and thus having other services that require a working network
            # connection starting too early).
            RequiredForOnline = "routable";
          };
          networkConfig = {
            # Let the DHCP server assign the IP address.
            DHCP = "yes";
            MulticastDNS = "yes";
            # Prevent this interface from being used as a default DNS route.
            # DNSDefaultRoute = false;
          };
          dhcpV4Config = {
            # Use systemd-resolved global DNS instead of the ones proviced by the DCHP server.
            UseDNS = false;
            # Prefer ethernet over Wi-Fi (lower takes precedence).
            RouteMetric = 100;
          };
          dhcpV6Config = {
            UseDNS = false;
            # There is no `RouteMetric` option in this section.
          };
          ipv6AcceptRAConfig = {
            UseDNS = false;
            RouteMetric = 100;
          };
        };

        "20-wlan" = {
          matchConfig = {
            Name = "wl*"; # `wlan0`, `wlan1`, etc.
          };
          linkConfig = {
            RequiredForOnline = "routable";
          };
          networkConfig = {
            DHCP = "yes";
            MulticastDNS = "yes";
            # DNSDefaultRoute = false;
          };
          dhcpV4Config = {
            UseDNS = false;
            # Lower priority than ethernet - try to have only one active
            # connection at a time, otherwise you might experience "Asymmetric
            # Routing" or "Reverse Path Filtering (RPF)" conflicts.
            RouteMetric = 600;
          };
          dhcpV6Config = {
            UseDNS = false;
            # There is no `RouteMetric` option in this section.
          };
          ipv6AcceptRAConfig = {
            UseDNS = false;
            RouteMetric = 600;
          };
        };
      };
    };

    # [1] https://man.archlinux.org/man/systemd.network.5
    #     https://wiki.archlinux.org/title/Systemd-networkd
    # [2] https://man.archlinux.org/man/systemd.network.5#%5BMATCH%5D_SECTION_OPTIONS
    # [3] See https://bugs.archlinux.org/task/70892

    # -------------------------------------------------------------------------
    # systemd-resolved
    # -------------------------------------------------------------------------

    # Disable conflicting services [5]
    networking.resolvconf.enable = false;

    # Enable and configure resolved
    services.resolved = {
      enable = true;
      settings.Resolve = {
        # CloudFlare DNS servers as primary option
        DNS = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        # Quad9 DNS servers as fallback
        FallbackDNS = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
        # Make the Global interface the default for all DNS queries that do not
        # match any more specific routing domain on other interfaces [1].
        # This does not affect queries of domain names that match the more
        # specific search domains specified in per-link configuration, they will
        # still be resolved using their respective per-link DNS servers.
        Domains = "~.";
        # Encrypt DNS queries whenever possible [2]. Fallback to unencrypted
        # queries if the DNS server does not support it to avoid DNS resolution
        # failure.
        # To verify that DNS over TLS is being used run `ngrep port 853`, it
        # should produce encrypted output. On the other hand `ngrep port 53`
        # should produce no output at all.
        DNSOverTLS = "opportunistic";
        # Verify DNS signatures whenever possible [3]. This totally depends on
        # the domains being queried, allow downgrade to allow access to
        # real-world sites (old or small sites) that do not have this enabled.
        DNSSEC = "allow-downgrade";
        # Enable zero-configuration local name resolution [4]. Common for
        # discovering printers, Chromecast, AirPlay, smart devices. Implemented
        # by Avahi (Linux) or Bonjour (Apple).
        MulticastDNS = true;
      };
    };

    # [1] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#Domains=
    # [2] https://wiki.archlinux.org/title/Systemd-resolved#DNS_over_TLS
    #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSOverTLS=
    # [3] https://wiki.archlinux.org/title/Systemd-resolved#DNSSEC
    #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSSEC=
    # [4] https://wiki.archlinux.org/title/Systemd-resolved#mDNS
    #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#MulticastDNS=
    # [5] https://tailscale.com/blog/sisyphean-dns-client-linux

    # -------------------------------------------------------------------------
    # Wi-Fi authentication
    # -------------------------------------------------------------------------

    # Iwd brings the wireless link up (scans, authenticates, associates).
    # Systemd-networkd configures IP/DNS after iwd has brought the link up. [1]
    networking.wireless.iwd.enable = true;
    # The user must be a member of the `wheel` group to manage iwd [2]
    users.users.${user}.extraGroups = [ "wheel" ];

    # impala provides a TUI interface for iwd [3]
    environment.systemPackages = [ pkgs.impala ];

    # [1] https://wiki.archlinux.org/title/Iwd
    # [2] https://wiki.archlinux.org/title/Iwd#Usage
    # [3] https://wiki.archlinux.org/title/Iwd#Installation
  };
}

# ---
#
# Systemd-networkd is configured declaratively - perfect for Nixos management.
#
# `networkctl` [1] is primarily used to query network configuration, the few
# state changes you will ever do with it are added to "drop-in" files that do
# not affect the main `.network` files [2].
#
# Changes in "drop-in" files are invisible to NixOS, hence not reproducible.
#
# [1] https://man.archlinux.org/man/networkctl.1.en
# [2] https://man.archlinux.org/man/systemd.network.5#DESCRIPTION
#
# ---
#
# Systemd-networkd offers full integration with systemd-resolved.
#
# Systemd-networkd configurations [1] take precedence over systemd-resolved
# configurations [2]. This allows you to set per-link configurations.
#
# We instruct systemd-networkd to inform systemd-resolved to ignore the
# default DNS Servers received from the DHCP server (ISP router).
#
# [1] https://man.archlinux.org/man/systemd.network.5
# [2] https://man.archlinux.org/man/resolved.conf.5
#
# ---
#
# systemd-resolved [1] provides a DNS stub listener in 127.0.0.53 that caches
# resolved queries to make subsequent queries much faster.
#
# You can change global DNS servers at runtime by executing
# `sudo resolvectl dns <interface> <DNS IP>`. To undo the changes just
# restart the systemd-networkd service.
#
# Use `resolvectl status` to check DNS servers being currently used.
#
# [1] https://wiki.archlinux.org/title/Systemd-resolved
#
# ---
#
# Tailscale lets you force any device in your tailnet to use your tailnet DNS
# settings instead of its local DNS settings [1][2]
#
# [1] https://tailscale.com/docs/reference/dns-in-tailscale?tab=macos#override-dns-servers
# [2] https://tailscale.com/blog/sisyphean-dns-client-linux

# ---
#
# systemd-networkd is ligher and faster than NetworkManager.
#
# It does not come with a builtin wireless daemon. We need to add `iwd` to
# manage Wi-Fi networks - `impala` is a TUI for iwd.
#
# It does not run background processes - e.g. it won't automatically switch to
# another Wi-Fi network, you need to do that manually.
#
# It lacks the ability to automatically open "login pages" when connecting to
# public networks using captive portals - you need to trigger those manually.
# Run `networkctl status <wlan>` and look for the "Captive Portal" field,
# then manually open the portal in your browser using the URL shown, or try
# accessing `http://neverssl.com` or `http://captive.apple.com` to trigger the
# redirect.
