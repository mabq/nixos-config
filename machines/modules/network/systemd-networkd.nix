# Systemd-networkd was designed to be configured declaratively, making it a
# perfect match for NixOS.
#
# Read [1] and [2] to learn where systemd-networkd looks for configuration
# files and how it prioritize them (the numbered prefix is important).
#
# `networkctl` [3] can be used to instrospect and control systemd-networkd at
# runtime. The few changes it allows are stored in "drop-in" files that do not
# modify the main configuration file - also explained in [2].
#
# Being part of systemd it offers much better integration with systemd-resolved.
#
# For more information see the ArchWiki [4].
#
# ---
#
# systemd-networkd is ligher and faster that NetworkManager, but it also has
# less builtin features.
#
# It does not come with a builtin wireless adapter - use `iwd` + `impala` [4]
# to manage Wi-Fi authentication.
#
# It won't automatically switch to another Wi-Fi network, you need to do that
# manually.
#
# It lacks the ability to automatically open "login pages" when connecting to
# public networks using captive portals - you need to trigger those manually,
# just run `networkctl status <wlan>` and look for the "Captive Portal" field,
# then manually open the portal in your browser using the URL shown, or try
# accessing `http://neverssl.com` or `http://captive.apple.com` to trigger the
# redirect.
#
# ---
#
# [1] https://man.archlinux.org/man/systemd-networkd.8.en
# [2] https://man.archlinux.org/man/systemd.network.5
# [3] https://man.archlinux.org/man/networkctl.1.en
# [4] https://wiki.archlinux.org/title/Systemd-networkd
# [5] TUI for managing wifi authentication.

{config, pkgs, lib, ...}:
{
  imports = [ ./systemd-resolved.nix ];

  systemd.network = {
    enable = lib.mkDefault true;
    networks = { # [1]
      "20-ethernet" = {
        matchConfig.Name = "en* eth*"; # `enp3s0`, `eno1`, etc.
        linkConfig.RequiredForOnline = "routable"; # [1]
        networkConfig.DHCP = "yes";
        dhcpV4Config = {
          UseDNS = "no"; # [5]
          RouteMetric = 100; # [2]
        };
        dhcpV6Config = {
          UseDNS = "no";
          RouteMetric = 100;
        };
        ipv6AcceptRAConfig.UseDNS = false; # [3]
      };
      "20-wlan" = {
        matchConfig.Name = "wl*"; # `wlan0`, `wlan1`, etc.
        linkConfig.RequiredForOnline = "routable";
        networkConfig.DHCP = "yes";
        dhcpV4Config = {
          UseDNS = "no";
          RouteMetric = 600; # lower priority than wired connections
        };
        dhcpV6Config = {
          UseDNS = "no";
          RouteMetric = 600;
        };
        ipv6AcceptRAConfig.UseDNS = false;
      };
    };
  };

  # Do not create any automatic network configuration files
  networking.useDHCP = false; # [4]

  # Use iwd to handle Wi-Fi authentication, scanning, and connection.
  # systemd-networkd handles IP configuration (DHCP, static IP, etc.) on the
  # wireless interface after iwd connects it.
  networking.wireless.iwd.enable = lib.mkDefault true;

  # Impala is a TUI for managing Wi-Fi.
  environment.systemPackages = [ pkgs.impala ];
}

# [0] The first (in alphanumeric order) of the network files that matches a
# given interface is applied, all later files are ignored, even if they match
# as well.
#
# [1] Prevent `systemd-networkd-wait-online.service` (enabled by default) from
# exiting before network interfaces have a routable IP address (and thus having
# other services that require a working network connection starting too early).
#
# [2] systemd-networkd does not set per-interface-type default route metrics,
# so it needs to be configured manually. When both wireless and wired devices
# on the system have active connections, the kernel will use the metric
# to decide on-the-fly which one to use.
#
# [3] Disable DNS from IPv6 Router Advertisements. This was blocking the
# interface from using the Global DNS servers of systemd-resolved.
#
# [4] Leaving this option enabled (default) creates `99-<name>.network`
# files in `/etc/systemd/network/`. These end up managing interfaces for
# which you did not create any files, which could be confusing.
#
# [5] Use Global DNS servers defined by systemd-resolved. To see how to change
# those at runtime see notes on the systemd-resolved module.
