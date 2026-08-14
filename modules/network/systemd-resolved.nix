# Import this module to use systemd-resolved for DNS resolution
{ lib, ... }:
with lib;
{
  # ----------------------------------------------------------------------------
  # Disable conflicting options
  #  These options are enabled by default and must be disabled to avoid
  #  conflicts with networkd and resolved.
  # ----------------------------------------------------------------------------

  # Disable default resolveconf in favor of systemd-resolved [4]
  networking.resolvconf.enable = mkDefault false;

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

      # Disable mDNS (multicast DNS) for .local domains to improve security.
      MulticastDNS = mkDefault false;
    };
  };

  # [1] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#Domains=
  # [2] https://wiki.archlinux.org/title/Systemd-resolved#DNS_over_TLS
  #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSOverTLS=
  # [3] https://wiki.archlinux.org/title/Systemd-resolved#DNSSEC
  #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSSEC=
  # [4] https://wiki.archlinux.org/title/Systemd-resolved#mDNS
  #     https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#MulticastDNS=
}

/*
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
