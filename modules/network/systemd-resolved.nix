# Used by networkmanager/systemd-networkd for DNS resolution.
{ lib, ... }:
with lib;
{
  # Disable default resolveconf to avoid conflicts with systemd-resolved
  networking.resolvconf.enable = mkDefault false;

  # Configure systemd-resolved
  #  https://nixos.wiki/wiki/Systemd-resolved
  #  https://wiki.archlinux.org/title/Systemd-resolved#Automatically
  services.resolved = {
    enable = mkDefault true;

    settings.Resolve = {

      # Use Quad9 DNS servers by default
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

      # Route all general DNS traffic to these DNS servers, unless a more
      # specific match exists. Domain names that match the more specific search
      # domain specified in per-link configuration will still be resolved using
      # their respective per-link DNS servers.
      #
      # If you prefer to use the DNS servers set in the Tailscale Admin
      # console:
      #  1. Enable the "Override DNS servers" in the Tailscale Admin console
      #     https://tailscale.com/docs/reference/dns-in-tailscale#override-dns-servers
      #  2. Comment out this line so that the DNS servers configured here are
      #     not used to route general DNS traffic.
      #  3. Enable the `--accept-dns` options
      #     https://tailscale.com/docs/reference/tailscale-cli#up
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

      # Disable mDNS (multicast DNS) for .local domains to improve security.
      MulticastDNS = mkDefault false;
    };
  };

}

/*
  Important!

  Per-link DNS configurations take precedence over systemd-resolved. Make sure
  you configure NetworkManager/systemd-networkd to ignore DNS settings obtained
  from DHCP servers.

  ---

  Use `resolvectl status` to check DNS servers being currently used.

  ---

  You can change global DNS servers at runtime by executing
  `sudo resolvectl dns <interface> <DNS IP>`. To undo the changes just
  restart systemd-networkd/networkmanager service.

  ---

  For configuration options see:
   https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html
*/
