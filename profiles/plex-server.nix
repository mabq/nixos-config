{ config, ... }:
{
  imports = [
    ../modules/network/systemd-networkd.nix

    ../modules/git.nix
    ../modules/keyd.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    # ../modules/starship.nix
  ];

  services.tailscale = {
    # Tailscale keys are decrypted by the user's module owning the Tailnet.
    #  https://tailscale.com/docs/features/access-control/auth-keys
    #  https://tailscale.com/docs/how-to/set-up-servers
    authKeyFile = config.sops.secrets."tailnetKey_mabqSharedTag".path;

    extraSetFlags = [
      # https://tailscale.com/docs/reference/tailscale-cli#set
      "--hostname=${config.networking.hostName}"
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
