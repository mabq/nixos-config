{ user, ... }:
{
  imports = [
    # You must pass the configName for each module or leave it empty to use the
    # default config file.

    (import ./hardware/keyd.nix { })

    (import ./programs/atuin.nix { configName = "simple"; })
    (import ./programs/bat.nix { })
    (import ./programs/btop.nix { })
    (import ./programs/git.nix { configName = user; })
    (import ./programs/neovim.nix { configName = user; })
    (import ./programs/starship.nix { configName = "simple"; })
    (import ./programs/tmux.nix { })
    (import ./programs/yazi.nix { })
    (import ./programs/zsh.nix { })

    ./modules/compositor/hyprland.nix
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
