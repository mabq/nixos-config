# NetworkManager as the network manager.
{
  lib,
  pkgs,
  user,
  ...
}:
with lib;
{
  imports = [
    ./modules/systemd-resolved.nix # DNS resolution
  ];

  # ----------------------------------------------------------------------------
  # Disable conflicting options
  #  These options are enabled by default and must be disabled to avoid
  #  conflicts with NetworkManager.
  # ----------------------------------------------------------------------------

  # Each network interface should be managed by only one DHCP client or network
  # manager. Disable NixOS default script-based DHCP configuration on all
  # interfaces. NetworkManager has its own built-in DHCP client daemon.
  networking.useDHCP = false;

  # Disable facter network configurations.
  hardware.facter.detected.dhcp.enable = false;

  # ----------------------------------------------------------------------------
  # NetworkManager
  #  https://wiki.archlinux.org/title/NetworkManager
  #  https://networkmanager.dev/docs/api/latest/settings-ipv4.html
  # ----------------------------------------------------------------------------

  networking.networkmanager = {
    enable = mkDefault true;

    # Instruct NetworkManager to ignore DNS servers obtained from DHCP on all
    # interfaces. This is important to let DNS resolution be managed by
    # systemd-resolved servers.
    dns = mkForce "none";
    settings.main."systemd-resolved" = false;
  };

  # Only members of the `networkmanager` group can use `nmtui` or `nmcli`
  users.users.${user}.extraGroups = [ "networkmanager" ];

  # ----------------------------------------------------------------------------
  # Extra packages
  # ----------------------------------------------------------------------------

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      dig # Domain name server
    ];
  };
}

/*
  NetworkManager is fundamentally imperative. Use `nmtui` or `nmcli` to manage
  network settings — settings are applied immediately [2], changes are
  persisted to disk [1] as a side effect, not as the primary action.

  NixOS configuration files [3] are immutable by design. NetworkManager
  configuration files [1] are mutable by design. So, configuration files
  created by NixOS options won't appear in [1], they are directly loaded
  to [2] when you rebuild the system.

  [1] `/etc/NetworkManager/system-connections/`
  [2] `/run/NetworkManager/`
  [3] `/nix/store/`
*/
