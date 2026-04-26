{ config, pkgs, user, ... }:
# let
#   repo = "${config.home.homeDirectory}/.local/share/nixos-config";
# in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  # home.file = {
  #   ".zshenv".text = ''ZDOTDIR="${repo}/users/${user}/zsh"'';
  # };

  # home.packages = with pkgs; [
    # opencode # AI coding agent built for the terminal
  # ];

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # programs.zsh = {
  #   autosuggestion.enable = true;
  # };
  
  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      setOptions = [ "NO_BEEP" ];
      initContent = ''
        # Bind Ctrl+Left and Ctrl+Right to move by words
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word

        # -- Delete word backward (Ctrl+Backspace)
        bindkey '^H' backward-kill-word           # Common sequence for Ctrl+Backspace
        bindkey '^[[3;5~' backward-kill-word      # Alternative sequence used by some terminals
      '';
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        enter_accept = false;
        show_numeric_shortcuts = false;
      };
      flags = [ "--disable-up-arrow" ];
    };
  };

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
