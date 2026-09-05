/*
  Used by network manager modules to manage DNS resolution.

  IMPORTANT!
   NetworkManager and systemd-networkd modules must be configured to ignore DNS
   servers obtained from DHCP. Per-link DNS servers take precedence over Global
   configurations.
*/

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

      # `~.` is systemd-resolved syntax to route all general DNS traffic to
      # these DNS servers, unless a more specific match exists — domain names
      # that match a more specific search domain specified in per-link
      # configuration will still be resolved using their respective per-link
      # DNS servers.
      #
      # If you prefer to use Tailscale DNS servers:
      #  1. Override this option on per-host basis.
      #     `services.resolved.settings.Resolve.Domains = lib.mkForce [""]`
      #  2. In the Tailscale Admin Console, enable the option "Override DNS servers".
      #     https://tailscale.com/docs/reference/dns-in-tailscale#override-dns-servers
      #  3. In the Tailscale Client, enable the `--accept-dns` flag.
      #     https://tailscale.com/docs/reference/tailscale-cli#up
      Domains = mkDefault [ "~." ];

      # DNS servers
      DNS = mkDefault [
        "9.9.9.9" # Quad9 (fastest)
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      FallbackDNS = mkDefault [
        "1.1.1.1" # CloudFlare
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];

      # Encrypt DNS queries whenever possible. Fallback to unencrypted queries
      # if the DNS server does not support it to avoid DNS resolution failure.
      #
      # To verify that DNS over TLS is being used run `ngrep port 853`, it
      # should produce encrypted output. `ngrep port 53` should produce no
      # output.
      DNSOverTLS = mkDefault "opportunistic";

      # Verify DNS signatures whenever possible. Depends on the domains being
      # queried, allow downgrade to allow access to real-world sites (old or
      # small sites) that do not have this feature enabled.
      DNSSEC = mkDefault "allow-downgrade";

      # Disable mDNS (multicast DNS) for .local domains to improve security.
      MulticastDNS = mkDefault false;
    };
  };

}

/*
  Systemd-resolved provides the `resolvectl` command for all related DNS
  actions. See `resolvectl help` or read its man page `man resolvectl`.

  For example, you can change global DNS servers at runtime by executing
  `sudo resolvectl dns <interface> <DNS IP>`. To undo the changes just restart
  the systemd-networkd or NetworkManager service.

  For configuration options see:
   https://www.freedesktop.org/software/systemd/man/latest/resolved.conf.html
*/
