{ config, ... }:
{
  imports = [
    ../modules/network/networkmanager.nix

    ../modules/git.nix
    ../modules/keyd.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    # ../modules/starship.nix
  ];

  services.tailscale = {
    enable = true;
    # Tailscale keys are decrypted by the user module owning the Tailnet.
    #  https://tailscale.com/docs/features/access-control/auth-keys
    #  https://tailscale.com/docs/how-to/set-up-servers
    authKeyFile = config.sops.secrets."tailscale_mabq_sharedTagKey".path;
    # https://tailscale.com/docs/reference/tailscale-cli#up
    extraUpFlags = [ ];
    # https://tailscale.com/docs/reference/tailscale-cli#set
    extraSetFlags = [
      "--hostname=${config.networking.hostName}"
      # "--accept-dns" # no need with networkd
      # "--accept-routes"
      "--ssh"
    ];
  };

  # home-manager.users.${user} =
  #   { ... }:
  #   {
  #     home = {
  #       packages = with pkgs; [
  #       ];
  #     };
  #   };
}
