# To understand all the tools involved in DNS resolutions and their
# relationship read the learning notes (Linux > Network).
#
# systemd-resolved provides a DNS stub listener in 127.0.0.53 that caches
# resolved queries to make subsequent queries much faster.
#
# Both systemd-networkd and NetworkManager are configured to use the Global
# DNS servers defined here. You can change these at runtime [1].
#
# Use `resolvectl status` to check DNS servers being currently used.
#
# For more information see [2] or [3].
#
# ---
#
# [1] `sudo resolvectl dns <interface> <DNS IP>`, you can undo the change by
# resetting the `systemd-networkd` service.
#
# [2] https://wiki.archlinux.org/title/Systemd-resolved
#
# [3] `man 5 resolved.conf`

{config, pkgs, lib, user, ...}:
{
  services.resolved = {
    enable = lib.mkDefault true;
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
      Domains = "~."; # [1]
      DNSOverTLS = "opportunistic"; # [2]
      DNSSEC = "allow-downgrade"; # [3]
      MulticastDNS = true; # [4]
    };
  };
}

# ---

# [1] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#Domains=
# [2] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSOverTLS=
# [3] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#DNSSEC=
# [4] https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html#MulticastDNS=
