{
  config,
  # pkgs,
  # user,
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
    #  https://tailscale.com/docs/features/access-control/auth-keys
    #  https://tailscale.com/docs/how-to/set-up-servers
    authKeyFile = config.sops.secrets."tailscale_mabq_sharedTagKey".path;
    # https://tailscale.com/docs/reference/tailscale-cli#up
    extraUpFlags = [ ];
    # https://tailscale.com/docs/reference/tailscale-cli#set
    extraSetFlags = [
      "--hostname=${config.networking.hostName}"
      # Let the system use Tailscale DNS servers
      "--accept-dns"
      # "--accept-routes"
      "--ssh"
    ];
  };

  # home-manager.users.${user} =
  #   { ... }:
  #   {
  #     home = {
  #       packages = with pkgs; [ ];
  #     };
  #   };
}
