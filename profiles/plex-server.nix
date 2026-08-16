{ config, user, ... }:
{
  imports = [
    ../modules/network/systemd-networkd.nix
    # ../modules/shell/zsh.nix

    ../modules/programs/git.nix
    ../modules/programs/keyd.nix
    ../modules/programs/neovim.nix
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

  services.plex = {
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
