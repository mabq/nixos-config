# Use NetworkManager only on devices that frequently switch between Wi-Fi
# networks, otherwise use systemd-networkd (see note about ssh "hiccups" below).
#
# NetworkManager is fundamentally imperative. You cannot simply drop a
# configuration file in [1] and have it "just work" without telling
# NetworkManager to load it first [4]. Connection files are considered state
# storage, not source of truth. The actual source of truth is NetworkManager's
# internal state [2].
#
# The intended workflow is to use `nmtui` or `nmcli` to modify live state, this
# way settings are applied immediately [2], changes are persisted to disk [1]
# as a side effect, not as the primary action.
#
# NixOS configuration files [3] are immutable by design and NetworkManager
# configuration files [1] are mutable by design. So, configuration files
# created by NixOS options [7] won't appear in [1], they are directly loaded
# to [2] when you rebuild the system.
#
# ---
#
# NetworkManager thinks in connections, while systemd-resolved thinks in
# interfaces. When a connection is established, NetworkManager pushes the DNS
# parameters received from the DHCP server (ISP router) to systemd-resolved.
# These per-connection DNS Servers have precedence over systemd-resolved Global
# DNS Servers [6].
#
# The only way to disable this default behaviour is to configure each
# connection to "Ignore automatically obtained DNS parameters" with the
# `ignore-auto-dns` option [5].
#
# We cannot create connection configurations for Wi-FI networks in advanced
# (unknown names and passwords), but we can create an ethernet connection that
# has "Ignore automatically obtained DNS parameters" enabled by default (you
# can always create more if you need).

# Wi-Fi networks will use obtained DNS parameters by default which might be
# useful to connect to captive portals in public networks. To use
# systemd-resolved DNS servers just enable the "ignore automatically obtained
# DNS parameters" option for that connection with `nmtui`.
#
# Any changes made with imperative commands are not reproducible.
#
# ---
#
# SSH "hiccups" happen because NetworkManager periodically scans for nearby
# Wi-Fi networks to provide an updated list for the GUI or to check if a
# "better" known network is available. During a scan, the Wi-Fi card
# momentarily stops transmitting data to listen to other channels. This
# causes a spike in latency (jitter), which makes an interactive SSH session
# feel sluggish or "stuck" for a split second.
#
# systemd-networkd is much more static. Once it establishes a connection
# (usually via wpa_supplicant or iwd), it stays out of the way. It doesn't
# scan unless you tell it to.
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

{user, lib, ...}:
{
  imports = [ ./shared/systemd-resolved.nix ];

  networking.networkmanager = {
    enable = true;

    # Create an ethernet connection with `ignore-auto-dns` enabled by default
    ensureProfiles.profiles = {
      ethernet-nixos = { # name given to file in `/run/NetworkManager/system-connections`
        connection = {
          id = "ethernet-global-dns"; # connection name displayed in nmtui
          type = "ethernet";
        };
        ipv4 = {
          method = "auto"; # configure IP automatically
          ignore-auto-dns = true;
        };
        ipv6 = {
          method = "auto";
          ignore-auto-dns = true;
        };
      };
    };

  };

  # Only member of the `networkmanager` group can use `nmtui` or `nmcli`
  users.users.${user}.extraGroups = [ "networkmanager" ];
}
