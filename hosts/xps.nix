{ config, inputs, ... }:
let
  disk = "/dev/sda";
in
{
  imports = [
    # Manual installation:
    ./hardware-configuration/xps-20260724.nix

    # Nixos-anywhere:
    # inputs.disko.nixosModules.disko
    # ./disko/ext4-encrypted.nix
    # ./hardware-configuration/xps-20260729.nix # `nixos-generate-config`
  ];

  # Nixos-anywhere
  # disko.devices.disk.main.device = disk;
  # hardware.facter.reportPath = ./facter/xps-20260729.json; # `nixos-facter`

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;

  services.tailscale = {
    enable = true;
    # IMPORTANT!
    # This authkey is only unlocked by the user `mabq`.
    # Auth keys - https://tailscale.com/docs/features/access-control/auth-keys
    # Setting up servers - https://tailscale.com/docs/how-to/set-up-servers
    authKeyFile = config.sops.secrets."mabq_tailscale_sharedTag_authKey".path;
    extraUpFlags = [
      # Up — https://tailscale.com/docs/reference/tailscale-cli#up
      "--hostname=${config.networking.hostName}" # magic-dns name
      # These settings are secure since we own the Tailnet, do not
      # enable these for Tailnets you do not own.
      "--accept-dns"
      "--accept-routes"
      "--ssh"
    ];
    extraSetFlags = [
      # set — https://tailscale.com/docs/reference/tailscale-cli#set
    ];
  };
}

/*
  Disko configurations are used to partition the disk during installation and
  also to mount filessystems.

  See [Prepare Hardware Configuration](https://nix-community.github.io/nixos-anywhere/quickstart.html#8-prepare-hardware-configuration)
*/
