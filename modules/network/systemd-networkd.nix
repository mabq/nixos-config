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

{config, pkgs, lib, user, ...}:
{
  imports = [ ./systemd-resolved.nix ];

  # ---

  # Disable the legacy global DHCP
  networking.useDHCP = false; # [4][6]

  # (Optional but recommended) Disable the dhcpcd daemon entirely to avoid
  # conflicts where both try to manage the same interfaces.
  networking.dhcpcd.enable = false; # [6]

  # ---

  systemd.network = {
    enable = lib.mkDefault true;

    networks = { # [1]

      "10-ether" = {
        matchConfig = { # https://man.archlinux.org/man/systemd.network.5#%5BMATCH%5D_SECTION_OPTIONS
          Name = "en* eth*"; # Matching with `Type=ether` causes issues with containers because it also matches virtual Ethernet interfaces (`veth*`) - see https://bugs.archlinux.org/task/70892. Instead match by globbing the network interface name.
        };
        linkConfig = { # https://man.archlinux.org/man/systemd.network.5#%5BLINK%5D_SECTION_OPTIONS
          RequiredForOnline = "routable"; # Prevent `systemd-networkd-wait-online.service` (enabled by default) from exiting before network interfaces have a routable IP address (and thus having other services that require a working network connection starting too early).
        };
        networkConfig = { # https://man.archlinux.org/man/systemd.network.5#%5BNETWORK%5D_SECTION_OPTIONS
          DHCP = "yes";
          # DNSDefaultRoute = false; # # Prevent this interface from being the default DNS route
        };
        dhcpV4Config = { # https://man.archlinux.org/man/systemd.network.5#%5BDHCPV4%5D_SECTION_OPTIONS
          UseDNS = "no"; # [3][5]
          RouteMetric = 100; # [2]
        };
        dhcpV6Config = { # https://man.archlinux.org/man/systemd.network.5#%5BDHCPV6%5D_SECTION_OPTIONS
          UseDNS = "no";
          RouteMetric = 100;
        };
        ipv6AcceptRAConfig = { # https://man.archlinux.org/man/systemd.network.5#%5BIPV6ACCEPTRA%5D_SECTION_OPTIONS
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
          # DNSDefaultRoute = false; # # Prevent this interface from being the default DNS route
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

  # ---

  # iwd brings the wireless link up (scans, authenticates, associates),
  # systemd-networkd configures IP/DNS after iwd has brought the link up.
  networking.wireless.iwd = { # https://wiki.archlinux.org/title/Iwd
    enable = true;
    settings = { # https://wiki.archlinux.org/title/Iwd#Optional_configuration
      General = {
        EnableNetworkConfiguration = false; # https://wiki.archlinux.org/title/Iwd#Enable_built-in_network_configuration
      };
      Scan = {
        DisablePeriodicScan = true; # https://wiki.archlinux.org/title/Iwd#Disable_periodic_scan_for_available_networks
      };
    };
  };

  # impala provides a TUI interface for iwd.
  environment.systemPackages = [ pkgs.impala ]; # https://wiki.archlinux.org/title/Iwd#Installation
  users.users.${user}.extraGroups = [ "wheel" ]; # https://wiki.archlinux.org/title/Iwd#Usage

}

# ---

# [0] The first (in alphanumeric order) of the network files that matches a
# given interface is applied, all later files are ignored, even if they match
# as well.
#
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
#
# [6] It is advised to run only one DHCP client or network manager on the
# system. Find a list of the currently running services with
# `systemctl --type=service` and then stop or reconfigure those that conflict.
# https://wiki.archlinux.org/title/Systemd-networkd#Required_services_and_setup
#
