# Options specific to this host only!
{ user, ... }:
let
  # State version
  #  Version of NixOS at installation. DO NOT UPDATE this value afterwards.
  #  Must be set on per-host basis.
  stateVersion = "26.05";
in
{
  imports = [
    ./modules/disko/ext4-encrypted.nix
    ./modules/network/systemd-networkd.nix
  ];

  # Disko target disk
  #  wwn ids are more stable than `/dev/sdX` block devices.
  #  Must be ser on per-host basis.
  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x5000cca55ff314ed";

  # Boot loader
  boot.loader.grub.enable = true;
  # boot.loader.grub.device = # automatically set by disko

  # Facter report
  #  The `hardware-configuration.nix` file freezes a decision made at
  #  generation time (which kernel modules, which options) based on the NixOS
  #  version at that moment. If NixOS's recommendations change later, the file
  #  is stale until you regenerate it. The `facter.json` report instead freezes
  #  just the raw facts about the hardware, and the decision-making logic lives
  #  in the nixpkgs facter modules. As NixOS evolves, you get better decisions
  #  automatically on rebuild, without re-running detection on the physical
  #  machine.
  hardware.facter.reportPath = ./facter/xps.json;

  # State versions for NixOS and Home-Manager
  system.stateVersion = stateVersion;
  home-manager.users.${user}.home.stateVersion = stateVersion;
}
