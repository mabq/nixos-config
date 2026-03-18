# Read learning notes: Linux > Network > DNS section.

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
      Domains = "~.";
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
      MulticastDNS = true;
    };
  };
}
