{config, pkgs, lib, user, ...}:

{
  # ----------------------------------------------------------------------------
  # NetworkManager
  # ----------------------------------------------------------------------------

  # Add use to networkmanager group (required to connect)
  users.users.${user}.extraGroups = [ "networkmanager" ];

  # Disable dhcpcd to prevent conflicts (enabled by default)
  networking.dhcpcd.enable = false;

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Configure NetworkManager to use systemd-resolved DNS servers
  networking.networkmanager.dns = "systemd-resolved";

  networking.networkmanager.settings = {
    # Global DNS settings that apply to all connections
    global = {
      "dns" = "systemd-resolved";
    };
    # You can also use connection defaults
    "connection" = {
      "ipv4.ignore-auto-dns" = true;
      "ipv6.ignore-auto-dns" = true;
    };
  };

  # ----------------------------------------------------------------------------
  # DNS
  # ----------------------------------------------------------------------------

  # Disable resolvconf to prevent conflics
  networking.resolvconf.enable = false;

  # Enable systemd-resolved
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        Domains = [ "~." ];
        DNSSEC = true;
        DNSOverTLS = true;
        #DNS = ; # defaults to `config.networking.nameservers`
      };
    };
  };

  # Use Cloudflare/Google DNS over IPS ones.
  networking.nameservers = [
    "1.1.1.1" # Cloudflare primary
    "1.0.0.1" # Cloudflare secondary
    "2606:4700:4700::1111" # Cloudflare IPv6 primary
    "2606:4700:4700::1001" # Cloudflare IPv6 secondary
    "8.8.8.8" # Google primary
    "8.8.4.4" # Google secondary
    "2001:4860:4860::8888" # Google IPv6 primary
    "2001:4860:4860::8844" # Google IPv6 secondary
  ];
}
