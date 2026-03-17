# TODO:
#  - `/etc/resolv.conf` is not pointing to systemd dir.

{config, pkgs, lib, ...}:

let
  interface_dns_servers = [
    # Cloudflare IPv4 and IPv6 as primary
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
    # Google IPv4 and IPv6 as fallback
    "8.8.8.8"
    "8.8.4.4"
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
  ];
  interface_network_options = {
    DHCP = "yes"; # Enables DHCPv4 and/or DHCPv6 client support.
    MulticastDNS = true; # Allow this host to talk to other devices on the local network using their names.
    DNSSEC = true; # Signs DNS records for authenticity & integrity (prevents tampering/spoofing). Fully supported by Cloudflare.
    DNSOverTLS = true; # Encrypts DNS queries/responses (privacy from eavesdropping). Fully supported by cloudflare.
  };
  interface_link_options = {
    RequiredForOnline = "routable"; # The link has carrier and routable address configured.
  };
in {
  #############################################################################

  # Create networkd configuration files.
  #
  #   > Documentaion: `man systemd-network`
  #
  #   > Files: `/etc/systemd/network/`
  #
  #   > Command: `networkctl <SUBCOMMAND>`
  #
  #   > Service: `systemd-networkd`
  #
  # The first (in alphanumeric order) of the network files that matches a given
  # interface is applied, all later files are ignored, even if they match as well.
  #
  # If no match is found the interface remains unmanaged. To avoid that we
  # allow NixOS to create "fallback" default network configuration files.
 
  networking.useNetworkd = lib.mkDefault true;

  # Create networkd configuration files.
  systemd.network.networks = {
    "20-ethernet" = {
      # This file matches wired connections - `senp3s0`, `eno1`, etc.
      matchConfig.Name = "en* eth*";
      linkConfig = interface_link_options;
      networkConfig = interface_network_options;
      dns = interface_dns_servers;
      # Prefer ethernet over Wi-Fi.
      dhcpV4Config.RouteMetric = 100;
      dhcpV6Config.RouteMetric = 100;
    };
    "20-wlan" = {
      # This file matches Wi-Fi (802.11) connections - `wlan0`.
      matchConfig.Name = "wl*";
      linkConfig = interface_link_options;
      networkConfig = interface_network_options;
      dns = interface_dns_servers;
      # Prefer wi-fi over Mobile.
      dhcpV4Config.RouteMetric = 600;
      dhcpV6Config.RouteMetric = 600;
    };
    "20-wwan" = {
      # This file matches Cellular (4G/5G/LTE) connections.
      matchConfig.Name = "ww*";
      linkConfig = interface_link_options;
      networkConfig = interface_network_options;
      dns = interface_dns_servers;
      dhcpV4Config.RouteMetric = 700;
      dhcpV6Config.RouteMetric = 700;
    };
  };

  # Let NixOS create "fallback" configuration files (default)
  #  - `/etc/systemd/network/99-ethernet-default-dhcp.network`
  #  - `/etc/systemd/network/99-wireless-client-dhcp.network`
  networking.useDHCP = true;

  #############################################################################

  # Setup DNS catching with systemd-resolved.
  #
  #   > Documentaion: `man 5 resolved.conf`
  #
  #   > Files: `/etc/resolv.conf` -> `/etc/systemd/resolved.conf`
  #   TODO: Disable tailscale to see if this happens
  #
  #   > Command: `resolvectl <SUBCOMMAND>`
  #
  #   > Service: `systemd-resolved`
  #
  # Most of the same options you can configure for resolved can be configured
  # by networkd per interface basis.
  #
  # No need to set any options here, networkd passes those options to resolved.
 
  services.resolved.enable = lib.mkDefault true;

  #############################################################################

  # Wi-Fi authentication tools.
  #
  # Unlike NetworkManager, networkd does not have a client to handle Wi-Fi
  # authentication. So we need to install the following tools.
 
  # Internet wireless daemon (required by impala)
  networking.wireless.iwd.enable = true;

  # TUI for managing wifi authentication
  environment.systemPackages = [ pkgs.impala ];
}
