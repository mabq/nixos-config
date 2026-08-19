{
  config,
  user,
  pkgs,
  repoDir,
  ...
}:
{
  imports = [
    ../modules/network/systemd-networkd.nix
    ../modules/shell/zsh.nix

    ../modules/programs/btop.nix
    ../modules/programs/git.nix
    ../modules/programs/keyd.nix
    ../modules/programs/neovim.nix
  ];

  services = {
    tailscale = {
      # This key must be opened by the user's module.
      authKeyFile = config.sops.secrets."mabqTailnet_sharedTagKey".path;
      # For possible flags see https://tailscale.com/docs/reference/tailscale-cli#set
      extraSetFlags = [ "--ssh" ];
    };

    plex = {
      # Configure Plex via `http://<SERVER-IP>:32400/web`
      enable = true;
      openFirewall = true;
      user = "${user}"; # ⚠️ should not run as my user, it could read secret files only readble by me
    };
  };

  programs.niri.enable = true;

  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          brave
          fuzzel
          foot
        ];
        file = {
          ".config/foot/foot.ini" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/foot/foot.ini";
            force = true;
          };
        };
      };
    };

  environment.sessionVariables = {
    # Required to run brave in wayland mode
    NIXOS_OZONE_WL = "1";
  };
}
