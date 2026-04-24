{ config, user, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.local/share/nixos-config/users/${user}";
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  programs.zsh.dotDir = "${dotfiles}/zsh";

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
