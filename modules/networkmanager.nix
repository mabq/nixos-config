# Import this module if you want to use NetworkManager as the network manager.
{
  config,
  lib,
  user,
  ...
}:
with lib; {
  # Do not create DHCP configurations based on facter file
  hardware.facter.detected.dhcp.enable = mkDefault false;

  # Make sure systemd-networkd is not enable
  systemd.network.enable = mkForce false;

  # --- NetworkManager ---

  networking.networkmanager.enable = mkDefault true;

  # Only members of the `networkmanager` group can use `nmtui` or `nmcli`
  users.users.${user}.extraGroups = ["networkmanager"];
}
# ---
#
# Use NetworkManager only as fallback option when systemd-networkd is not
# appropiate for some reason.
#
# NetworkManager is fundamentally imperative. Use `nmtui` or `nmcli` to modify
# live state - settings are applied immediately [2], changes are persisted to
# disk [1] as a side effect, not as the primary action.
#
# NixOS configuration files [3] are immutable by design. NetworkManager
# configuration files [1] are mutable by design. So, configuration files
# created by NixOS options [7] won't appear in [1], they are directly loaded
# to [2] when you rebuild the system.
#
# If you wish to use custom DNS servers, configure those manually with `nmtui`.
# Mixing NetworkManager with systemd-resolved is not ideal.
#
# ---
#
# When using ssh via Wi-FI you will notice some "hiccups", this happens because
# NetworkManager periodically scans for nearby Wi-Fi networks to provide an
# updated list for the GUI or to check if a "better" known network is available.
# During a scan, the Wi-Fi card momentarily stops transmitting data to listen
# to other channels. This causes a spike in latency (jitter), which makes an
# interactive SSH session feel sluggish or "stuck" for a split second.
#
# ---
#
# [1] `/etc/NetworkManager/system-connections/`
# [2] `/run/NetworkManager/`
# [3] `/nix/store/`
# [4] `nmcli connection reload <connection>`
# [5] https://networkmanager.dev/docs/api/latest/settings-ipv4.html
# [6] `resolvectl status`
# [7] https://search.nixos.org/options?channel=unstable&query=networking.networkmanager

