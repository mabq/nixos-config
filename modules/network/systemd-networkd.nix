{ config, pkgs, lib, user, ... }:
{
  imports = [
    ./local/disable-conflicting-services.nix
    ./local/systemd-resolved.nix
  ];

  # ---------------------------------------------------------------------------
  # Configure systemd-networkd
  # ---------------------------------------------------------------------------

  systemd.network = {
    enable = lib.mkDefault true;

    # Configuration options for `.network` files [1]
    networks = {

      "10-ether" = {
        matchConfig = {
          # The `[MATCH]` section determines which file is used to configure
          # each interface. Only the first one to match is used - reason for
          # number prefix. [2]
          #
          # Matching with `Type=ether` causes issues with containers because it
          # also matches virtual Ethernet interfaces (`veth*`). [3]
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
          DHCP = "yes";
          MulticastDNS = "yes";
          # Prevent this interface from being used as a default DNS route.
          # DNSDefaultRoute = false;
        };
        dhcpV4Config = {
          # Don't use DNS servers obtained from DHCP server
          UseDNS = "no";
          # Prefer ethernet over Wi-Fi (lower takes precedence)
          RouteMetric = 100;
        };
        dhcpV6Config = {
          UseDNS = "no";
          RouteMetric = 100;
        };
        ipv6AcceptRAConfig = {
          UseDNS = "no";
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
          UseDNS = "no";
          RouteMetric = 600;
        };
        dhcpV6Config = {
          UseDNS = "no";
          RouteMetric = 600;
        };
        ipv6AcceptRAConfig = {
          UseDNS = "no";
          RouteMetric = 600;
        };
      };

    };

  };

  # [1] https://man.archlinux.org/man/systemd.network.5
  #     https://wiki.archlinux.org/title/Systemd-networkd
  # [2] https://man.archlinux.org/man/systemd.network.5#%5BMATCH%5D_SECTION_OPTIONS
  # [3] See https://bugs.archlinux.org/task/70892

  # ---------------------------------------------------------------------------
  # Wi-Fi tools
  # ---------------------------------------------------------------------------

  # iwd brings the wireless link up (scans, authenticates, associates).
  # systemd-networkd configures IP/DNS after iwd has brought the link up. [1]
  networking.wireless.iwd.enable = lib.mkDefault true;
  # The user must be a member of the `wheel` group to manage iwd [2]
  users.users.${user}.extraGroups = [ "wheel" ]; 

  # impala provides a TUI interface for iwd [3]
  environment.systemPackages = [ pkgs.impala ]; 

  # [1] https://wiki.archlinux.org/title/Iwd
  # [2] https://wiki.archlinux.org/title/Iwd#Usage
  # [3] https://wiki.archlinux.org/title/Iwd#Installation

}

# ----------------------------------------------------------------------------- 
# Additional notes
# ----------------------------------------------------------------------------- 
#
# With this setup, all the commands you need to manage the network are `ip`,
# `networkctl` and `resolvectl`.
#
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
# Here we instruct systemd-networkd to inform systemd-resolved to ignore the
# default DNS Servers received from the DHCP server (ISP router).
#
# [1] https://man.archlinux.org/man/systemd.network.5
# [2] https://man.archlinux.org/man/resolved.conf.5
#
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
