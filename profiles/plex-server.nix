{ pkgs, user, ... }:
let
  stateVersion = "26.05"; # only update when reinstalling with a newer ISO
in
{
  imports = [
    ../modules/defaults.nix
    ../modules/git.nix
    ../modules/keyd.nix
    ../modules/neovim.nix
    ../modules/networkmanager.nix
    # ../modules/starship.nix
    ../modules/tmux.nix
  ];
  options = { };

  config = {
    networking.firewall.enable = false;

    system.stateVersion = stateVersion;

    home-manager.users.${user} =
      { ... }:
      {
        options = { };

        config = {
          home = {
            packages = with pkgs; [
              just # Handy way to save and run project-specific commands
            ];
            stateVersion = stateVersion;
          };
        };
      };
  };
}
