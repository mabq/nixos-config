{ config, pkgs, user, ... }:
let
  repo = "${config.home.homeDirectory}/.local/share/nixos-config";
  dotfiles = "${repo}/users/${user}/dotfiles";
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.file = {
    ".zshenv".text = ''ZDOTDIR="${dotfiles}/zsh"'';
  };

  home.packages = with pkgs; [
    eza # Modern, maintained replacement for ls
    opencode # AI coding agent built for the terminal
    starship # Minimal, blazing fast, and extremely customizable prompt for any shell
    zoxide # Fast cd command that learns your habits
  ];

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # programs.zsh = {
  #   autosuggestion.enable = true;
  # };
  
  # programs.atuin = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   settings = {
  #     enter_accept = false;
  #   };
  # };

  xdg = {
    enable = true;
    # Manage xdg directories, e.g.  ~/.config, ~/.local/share, etc.
    userDirs = {
      enable = true;
      setSessionVariables = true; # Create XDG variables automatically.
      createDirectories = true; # Automatically create ~/Downloads, etc.
      extraConfig = {
        SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };

    # -- Default apps
    # Declarative way of configuring `~/.config/mimeapps.list`. Changes
    # instroduced with the imperative command `xdg-mime default ...` will be
    # overriden on next reboot.
    #
    # To setup a default app, first check the MIME type of the file with
    # `xdg-mime query filetype <file>`, then check the available `.desktop`
    # files in directories included in $XDG_DATA_DIRS. Finally, link a MIME
    # type to a .desktop file here.
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "brave-browser.desktop";
        "application/pdf" = "brave-browser.desktop";
        "image/png" = "imv.desktop";
      };
    };
    desktopEntries = {
      # my-custom-app = {
      #   name = "My Custom App";
      #   genericName = "Text Editor";
      #   exec = "my-script %U";
      #   terminal = false;
      #   categories = [ "Application" "Development" ];
      #   icon = "accessories-text-editor";
      # };
    };
  };
}
