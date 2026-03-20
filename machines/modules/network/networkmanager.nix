# NetworkManager manages configurations through connections, not interfaces.
#
# To stop NetworkManager influencing systemd-resolved with DNS settings
# obtained via DHCP you would need to do a per-connection configuration
# here via `networking.networkmanager.ensureProfiles.profiles.<name>.ipv4.ignore-auto-dns = true;`
# which is totally impractical.
#
# Use `nmtui`/`nmcli` to set per-connection DNS servers manually. To use the
# DNS servers configured by systemd-resolved simple check the box that says
# "Ignore automatically obtained DNS parameters" under IPv4 and IPv6 sections.
#
# Restart networkmanager and systemd-resolved services and run
# `resolvectl status` to verify changes. If connected via ssh you may need to
# disconnect/re-connect to see the changes applied to the interface being used
# by the ssh connection.
#
# You can check NetworkManager 

{user, ...}:
{
  imports = [
    ./systemd-resolved.nix
  ];

  networking.networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      Ethernet = {
        connection = {
          id = "Ethernet (DNS)";
          type = "ethernet";
        };
        ipv4 = {
          method = "auto";
          ignore-auto-dns = true;
        };
        ipv6 = {
          method = "auto";
          ignore-auto-dns = true;
        };
      };
      Wifi = {
        connection = {
          id = "Wifi (DNS)";
          type = "Wi-Fi";
        };
        ipv4 = {
          method = "auto";
          ignore-auto-dns = true;
        };
        ipv6 = {
          method = "auto";
          ignore-auto-dns = true;
        };
      };
    };
  };

  # User needs to be a member of the `networkmanager` group in order to use
  # `nmtui` or `nmcli`.
  users.users.${user}.extraGroups = [ "networkmanager" ];
}
