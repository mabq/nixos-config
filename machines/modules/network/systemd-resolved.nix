# Read learning notes: Linux > Network > DNS section.

#############################################################################

# SETUP DNS CATCHING WITH SYSTEMD-RESOLVED.
#
#   > Documentaion: `man 5 resolved.conf`
#
#   > Files: `/etc/resolv.conf` -> `/etc/static/resolv.conf`
#
#   > Command: `resolvectl <SUBCOMMAND>`
#
#   > Service: `systemd-resolved.service`
#
# Most of the same options you can configure for resolved can be configured
# by networkd per interface basis.
#
# No need to set any options here, networkd passes those options to resolved.
#
# systemd-resolved prioritizes per-link DNS servers over global ones when a
# link has +DefaultRoute (which enp3s0 has). Your ISP router is advertising
# itself as a DNS resolver via DHCP or IPv6 Router Advertisements.
#
# TODO: Different DNS servers for different domains.
#
#############################################################################

{config, pkgs, lib, user, ...}:
{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [ # CloudFlare
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];
      FallbackDNS = [ # Quad9
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      Domains = "~."; # creates a global routing domain that ensures all DNS queries go through your specified global servers rather than any link-specific ones
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
      MulticastDNS = true;
    };
  };
}
