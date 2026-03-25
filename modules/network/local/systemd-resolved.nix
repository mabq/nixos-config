{lib, ...}:
{
  services.resolved = {
    enable = lib.mkDefault true;

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
}

# -----------------------------------------------------------------------------
# Additional notes
# -----------------------------------------------------------------------------
#
# To understand all the tools involved in DNS resolutions and their
# relationship read the learning notes (Linux > Network).
#
# systemd-resolved [1] provides a DNS stub listener in 127.0.0.53 that caches
# resolved queries to make subsequent queries much faster.
#
# Both systemd-networkd and NetworkManager are configured to use the Global
# DNS servers defined here. You can change these at runtime by executing
# `sudo resolvectl dns <interface> <DNS IP>`. To undo the changes just
# restart the systemd-networkd service.
#
# Use `resolvectl status` to check DNS servers being currently used.
#
# [1] https://wiki.archlinux.org/title/Systemd-resolved

