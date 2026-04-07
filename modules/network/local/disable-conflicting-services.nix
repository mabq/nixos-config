{ lib, ... }:
{
  # ---------------------------------------------------------------------------
  # Disable legacy DHCP services
  # ---------------------------------------------------------------------------

  # Leaving this option enabled (default) creates default `.network` config
  # files [1] that end up managing interfaces for which you did not create
  # configuration files here, causing confusion.
  networking.useDHCP = lib.mkDefault false;

  # Disable the dhcpcd daemon.
  networking.dhcpcd.enable = lib.mkDefault false;
 
  # [1] `/etc/systemd/network/99-<name>.network`

  # ---------------------------------------------------------------------------
  # Disable conflicting DNS resolution services
  # ---------------------------------------------------------------------------
 
  # Explicitly disable resolvconf [1]
  networking.resolvconf.enable = lib.mkDefault false;

  # [1] https://wiki.archlinux.org/title/Openresolv
}

# -----------------------------------------------------------------------------
# Additional notes
# -----------------------------------------------------------------------------
#
# Run only one DHCP client or network manager on the system to avoid
# conflicts where many tools end up managing the same interfaces [1]. By
# disabling these we let systemd-networkd or NetworkManager do the job alone
#
# If you suspect that there is more than one network manager or DHCP tool
# running at the same time, use `systemctl --type=service` to show all running
# services. Then stop or reconfigure those that conflict.
#
# [1] https://wiki.archlinux.org/title/Systemd-networkd#Required_services_and_setup
