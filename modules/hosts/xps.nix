{ user, ... }:

let
  stateVersion = "26.05"; # NixOS installer version. DO NOT UPDATE LATER!
in
{
  imports = [
    ./hardware-configuration/xps.nix
    # ../disko/ext4-encrypted.nix
  ];
  # disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x5000cca55ff314ed";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "xps";

  # Facter report
  #  `hardware-configuration.nix` freezes a decision made at generation time
  #  (which kernel modules, which options) based on the NixOS version at that
  #  moment. If NixOS's recommendations change later, the file is stale until
  #  you regenerate it. `facter.json` instead freezes just the raw facts about
  #  the hardware, and the decision-making logic lives in the nixpkgs facter
  #  modules. As NixOS evolves, you get better decisions automatically on
  #  rebuild, without re-running detection on the physical machine.
  # hardware.facter.reportPath = ./facter/xps.json;

  system.stateVersion = stateVersion;
  home-manager.users.${user}.home.stateVersion = stateVersion;
}
