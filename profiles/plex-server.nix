{ pkgs, user, ... }:
{
  imports = [
    ../modules/git.nix
    ../modules/keyd.nix
    ../modules/neovim.nix
    ../modules/networkmanager.nix
    # ../modules/starship.nix
    ../modules/tmux.nix
  ];

  services.openssh.settings.PasswordAuthentication = true;

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
