{config, pkgs, lib, ...}:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none"; # Disable NetworkManager's internal DNS management

  # Disable NixOS's default DHCP and resolvconf to prevent conflicts
  # networking.dhcpcd.enable = false; # deault true
  # Optional: Prevent DHCP from overriding your DNS settings
  # networking.dhcpcd.extraConfig = "nohook resolv.conf";

  # networking.resolvconf.enable = pkgs.lib.mkForce false;

  # networking.useDHCP = false;

  # Use Cloudflare/Google DNS over IPS ones.
  # This options writes to `/etc/resolv.conf`
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
  
  environment.systemPackages = with pkgs; [
    dig
  ];
}
