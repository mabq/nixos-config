# Import this module if you want to use NetworkManager.
{
  lib,
  pkgs,
  user,
  ...
}:
with lib;
{
  # Do not create DHCP configurations based on facter file
  hardware.facter.detected.dhcp.enable = mkDefault false;

  # Enable NetworkManager
  networking.networkmanager.enable = mkDefault true;

  # Only members of the `networkmanager` group can use `nmtui` or `nmcli`
  users.users.${user}.extraGroups = [ "networkmanager" ];

  # Install some packages with HomeManager
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      dig # Domain name server (provides the `nslookup` command to check DNS)
    ];
  };
}

/*
  NetworkManager is fundamentally imperative. Use `nmtui` or `nmcli` to modify
  live state - settings are applied immediately [2], changes are persisted to
  disk [1] as a side effect, not as the primary action.

  NixOS configuration files [3] are immutable by design. NetworkManager
  configuration files [1] are mutable by design. So, configuration files
  created by NixOS options [7] won't appear in [1], they are directly loaded
  to [2] when you rebuild the system.

  If you wish to use custom DNS servers, configure those manually with `nmtui`
  or let Tailscale override local DNS settings [8]. Mixing NetworkManager with
  systemd-resolved is not ideal.

  [1] `/etc/NetworkManager/system-connections/`
  [2] `/run/NetworkManager/`
  [3] `/nix/store/`
  [4] `nmcli connection reload <connection>`
  [5] https://networkmanager.dev/docs/api/latest/settings-ipv4.html
  [6] `resolvectl status`
  [7] https://search.nixos.org/options?channel=unstable&query=networking.networkmanager
  [8] https://tailscale.com/docs/reference/dns-in-tailscale?tab=linux#override-dns-servers
      https://tailscale.com/docs/reference/tailscale-cli#up
*/
