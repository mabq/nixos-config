{
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ../modules/networkmanager.nix
    ../modules/git.nix
    ../modules/keyd.nix
    ../modules/neovim.nix
    # ../modules/starship.nix
    ../modules/tmux.nix
  ];

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
      # about what features you want to enable for this machine. These must be
      # set on per-host basis since different machines might need to enable
      # different features.
      #
      # For information about flags that can be passed to the `up` command, read:
      #  https://tailscale.com/docs/reference/tailscale-cli#up
    ];

    extraSetFlags = [
      # Flags passed to the `set` command change any settings for the client
      # for the current Tailnet.
      #
      # For information about flags that can be passed to the `set` command, read:
      #  https://tailscale.com/docs/reference/tailscale-cli#set
      "--hostname=${config.networking.hostName}"
      "--accept-dns"
      # "--accept-routes"
      "--ssh"
    ];
  };

  home-manager.users.${user} =
    { ... }:
    {
      home = {
        packages = with pkgs; [
          just # Handy way to save and run project-specific commands
        ];
      };
    };
}
