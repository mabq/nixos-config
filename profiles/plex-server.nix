{ user, ... }:
{
  imports = [
    ../modules/network/systemd-networkd.nix

    ../modules/shell/zsh.nix

    ../modules/programs/btop.nix
    ../modules/programs/git.nix
    ../modules/programs/keyd.nix
    ../modules/programs/neovim.nix

    ../modules/compositor/hyprland.nix
  ];

  services.tailscale = {
    # This key must be opened by the user's module.
    # authKeyFile = config.sops.secrets."mabqTailnet_sharedTagKey".path;
    # For possible flags see https://tailscale.com/docs/reference/tailscale-cli#set
    extraSetFlags = [ "--ssh" ];
  };

  services.plex = {
    # Configure Plex via `http://<SERVER-IP>:32400/web`
    enable = true;
    openFirewall = true;
    user = "${user}"; # ⚠️ should not run as my user, it could read secret files only readble by me
  };
}
