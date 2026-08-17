{ config, user, ... }:
{
  imports = [
    ../modules/network/systemd-networkd.nix
    ../modules/shell/zsh.nix

    ../modules/programs/git.nix
    ../modules/programs/keyd.nix
    ../modules/programs/neovim.nix
  ];

  services.tailscale = {
    # Tailscale keys are decrypted by the user's module owning the Tailnet.
    #  https://tailscale.com/docs/features/access-control/auth-keys
    #  https://tailscale.com/docs/how-to/set-up-servers
    authKeyFile = config.sops.secrets."tailnetKey_mabqSharedTag".path;
    #  https://tailscale.com/docs/reference/tailscale-cli#set
    extraSetFlags = [ "--ssh" ];
  };

  services.plex = {
    # Configure Plex via `http://<SERVER-IP>:32400/web`
    enable = true;
    openFirewall = true;
    user = "${user}";
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
