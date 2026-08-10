{
  config,
  # inputs,
  ...
}:
let
  disk = "/dev/sda";
in
{
  imports = [
    # When installing NixOS manually:
    ./hardware-configuration/xps-20260724.nix

    # When installing with nixos-anywhere:
    # inputs.disko.nixosModules.disko
    # ./disko/ext4-encrypted.nix
    # ./hardware-configuration/xps-20260729.nix # https://nix-community.github.io/nixos-anywhere/quickstart.html#8-prepare-hardware-configuration
  ];

  # When installing with nixos-anywhere:
  # disko.devices.disk.main.device = disk;
  # hardware.facter.reportPath = ./facter/xps-20260729.json; # https://nix-community.github.io/nixos-anywhere/quickstart.html#81-nixos-facter

  boot.loader.grub.enable = true;
  boot.loader.grub.device = disk;

  services.tailscale = {
    enable = true;
    # Tailscale keys are decrypted by the user module owning the Tailnet.
    #
    # For information about Auth Keys, read:
    #  https://tailscale.com/docs/features/access-control/auth-keys
    #  https://tailscale.com/docs/how-to/set-up-servers
    authKeyFile = config.sops.secrets."tailscale_mabq_sharedTagKey".path;
    extraUpFlags = [
      # Flags passed to the `up` command instruct the Tailscale local client
      # about what features you want to enable for the machine. These must be
      # set on per-host basis since different machines might need to enable
      # different features.
      #
      # For information about flags that can be passed to the `up` command, read:
      #  https://tailscale.com/docs/reference/tailscale-cli#up
      "--hostname=${config.networking.hostName}"
      # "--accept-dns"
      # "--accept-routes"
      "--ssh"
    ];
    extraSetFlags = [
      # Flags passed to the `set` command change any settings for the client
      # for the current Tailnet.
      #
      # For information about flags that can be passed to the `set` command, read:
      #  https://tailscale.com/docs/reference/tailscale-cli#set
    ];
  };
}

/*
  Disko configurations are used to partition the disk during installation and
  also to mount filessystems.

  See [Prepare Hardware Configuration](https://nix-community.github.io/nixos-anywhere/quickstart.html#8-prepare-hardware-configuration)
*/
