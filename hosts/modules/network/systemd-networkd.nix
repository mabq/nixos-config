# systemd-networkd as the network manager.
{
  lib,
  pkgs,
  user,
  ...
}:
with lib;
{
  imports = [
    ./dependencies/systemd-resolved.nix # DNS resolution
  ];

  # ----------------------------------------------------------------------------
  # Disable conflicting options
  #  These options are enabled by default and must be disabled to avoid
  #  conflicts with systemd-networkd.
  # ----------------------------------------------------------------------------

  # Each network interface should be managed by only one DHCP client or network
  # manager. Disable NixOS default script-based DHCP configuration on all
  # interfaces. Systemd-networkd has its own built-in DHCP client daemon.
  networking.useDHCP = false;

  # Disable facter network configurations.
  hardware.facter.detected.dhcp.enable = false;

  # ----------------------------------------------------------------------------
  # Systemd-networkd
  #  https://nixos.wiki/wiki/Systemd-networkd
  #  https://wiki.archlinux.org/title/Systemd-networkd
  # ----------------------------------------------------------------------------

  # Don't use this option. In many tutorials this option is mentioned, it acts
  # as compatibility mechanism to translate older `networking.*` options into
  # networkd configurations. Since we are using native
  # `systemd.network.networks` declarations, it is unnecessary.
  # `networking.useNetworkd = true;`

  # Increase log details for possible debugging.
  #  https://nixos.wiki/wiki/Systemd-networkd#Debugging
  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  systemd.network = {
    enable = mkDefault true;

    # Consider the system "online" when any interface reaches "routable" state.
    wait-online.anyInterface = mkDefault true;

    # Configure network interfaces
    #  systemd-networkd uses first-match-wins semantics — when multiple
    #  .network files could match an interface, only the single
    #  highest-priority matching file's settings apply in full, that is why
    #  file names are prefixed with a number.
    #
    #  Virtual interfaces like `wg0` or `tailscale0` do not need to be
    #  configured. Only hardware links.
    #
    #  There is no global option to ignore DNS servers obtained from DHCP for
    #  all interfaces. We instruct all ethernet and wireless connections to do
    #  so.
    #
    #  For more info see:
    #   https://wiki.archlinux.org/title/Network_configuration#Network_interfaces
    #   https://wiki.archlinux.org/title/Systemd-networkd
    #   https://man.archlinux.org/man/systemd.network.5
    networks = {
      # Ethernet connection (highest priority)
      "10-ether" = {
        # Matching with `Type=ether` causes issues with containers because it
        # also matches virtual Ethernet interfaces like `veth*`. Its better to
        # use globbing to match the network interface name.
        #  https://bugs.archlinux.org/task/70892
        matchConfig.Name = mkDefault "en* eth*";

        # Prevent `systemd-networkd-wait-online.service` (enabled by default)
        # from exiting before network interfaces have a routable IP address
        # causing other services that require a working network connection
        # starting too early.
        linkConfig.RequiredForOnline = mkDefault "routable";

        networkConfig = {
          # Use DHCP, for other options like static IPs see:
          #  https://nixos.wiki/wiki/Systemd-networkd
          DHCP = mkDefault "yes";

          # Accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
          IPv6AcceptRA = mkDefault true;

          # Systemd-resolved supports per-link DNS configuration. Don't use the
          # DNS servers of this link (if any) for general/global queries (only
          # for domains you've explicitly routed to it via `Domains=`).
          DNSDefaultRoute = mkDefault false;
          # Domains = ;

          # Disable mDNS for .local domains to improve security.
          MulticastDNS = mkDefault "no";
        };
        dhcpV4Config = {
          # Ignore DNS servers obtained from the DHCP for IPv4 connections.
          UseDNS = mkDefault false;
          # Prefer wired connections — lower values take precedence.
          RouteMetric = mkDefault 100;
        };
        dhcpV6Config = {
          # Ignore DNS servers obtained from the DHCP for IPv6 connections.
          UseDNS = mkDefault false;
          # There is no `RouteMetric` option in this section.
        };
        ipv6AcceptRAConfig = {
          # Ignore DNS servers obtained from the DHCP for IPv6 connections.
          UseDNS = mkDefault false;
          RouteMetric = mkDefault 100;
        };
      };

      # Wireless connections (less priority)
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

  # ----------------------------------------------------------------------------
  # Tools to manage Wi-Fi connections
  # ----------------------------------------------------------------------------

  # Iwd brings the wireless link up (scans, authenticates, associates).
  # Systemd-networkd configures IP/DNS after iwd has brought the link up.
  #  https://wiki.archlinux.org/title/Iwd
  networking.wireless.iwd.enable = mkDefault true;

  # The user must be a member of the `wheel` group to manage iwd.
  #  https://wiki.archlinux.org/title/Iwd#Usage
  users.users.${user}.extraGroups = [ "wheel" ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      impala # TUI for managing wifi
      dig # Domain name server (provides the `nslookup` command to check DNS)
    ];
  };
}

/*
  Use systemd-networkd on devices where you don't need to switch between
  Wi-Fi networks constantly. It is faster and lighter than NetworkManager.
   https://nixos.wiki/wiki/Systemd-networkd#When_to_use.

  Systemd-networkd provides the `networkctl` command, see `networkctl help` or
  read its man page `man networkctl` to learn about it.

  ---

  If you need to connect to a network using a captive portal, you need to
  trigger those manually. Run `networkctl status <wlan>` and look for the
  "Captive Portal" field, then manually open the portal in your browser using
  the URL shown, or try accessing `http://neverssl.com` or
  `http://captive.apple.com` to trigger the redirect.
*/
