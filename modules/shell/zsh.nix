# Zsh as the main shell
{
  lib,
  pkgs,
  user,
  repoDir,
  ...
}:
with lib;
{
  imports = [
    ./dependencies/atuin.nix
    ./dependencies/bat.nix
    ./dependencies/starship.nix
    ./dependencies/tmux.nix
    ./dependencies/yazi.nix
  ];

  # Must be enabled to be used as the default shell
  programs.zsh.enable = mkDefault true;

  # Make it the default shell for the user
  users.users.${user}.shell = mkDefault pkgs.zsh;

  # Home-manager
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        exfatprogs # exFAT filesystem userspace utilities (!functions)
        eza # Modern, maintained replacement for ls (!alias)
        fd # Simple, fast and user-friendly alternative to find
        ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
        fzf # Command-line fuzzy finder
        imagemagick # Software suite to create, edit, compose, or convert bitmap images
        parted # Create, destroy, resize, check, and copy partitions
        ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
        zoxide # Fast cd command that learns your habits
        zsh-autosuggestions # Fish-like shell autosuggestions for Zsh
        zsh-history-substring-search # Fish-like shell history-substring-search for Zsh
        zsh-syntax-highlighting # Fish-like shell like syntax highlighting for Zsh
      ];

      file.".zshenv" = {
        text = ''
          ## Read notes in zsh nix module
          setopt NO_GLOBAL_RCS
          ZDOTDIR="${repoDir}/config/zsh"
        '';
        force = true;
      };
    };
  };
}

/*
  Shell Types
  ===========

    - Interactive:      Terminal windows
    - Non-interactive:  Running scripts
    - Login:            Initial login / SSH login

  Config files
  ============

  Zsh uses five main startup configuration files, each serving a specific
  purpose depending on whether the shell is interactive or non-interactive, and
  whether it is a login shell.

   System-level       User-level
   ------------       ----------
   `/etc/zshenv`      `~/.zshenv`
   `/etc/zprofile`    `~/.zprofile`
   `/etc/zshrc`       `~/.zshrc`
   `/etc/zlogin`      `~/.zlogin`
   `/etc/zlogout`     `~/.zlogout`

  System-wide versions located in `/etc/` are sourced right before their
  corresponding user-level files. So, `/etc/zshenv`, then `~/.zshenv`, then
  `/etc/zprofile`, then `~/.zprofile` and so on.

  zshenv
  ------

  System-level and user-level versions of this file are ALWAYS sourced,
  regardless of the shell type — meaning both files are executed every single
  time Zsh starts, including non-interactive scripts and remote commands.

  Keep this file as lightweight as possible to avoid slowing down script
  execution. Put only environment variables that must be available to all
  scripts, subshells, and applications. Do not put output commands, aliases, or
  prompt configurations here.

  The system-level file is controlled by NixOS and only includes basic stuff.

  The user-level file is created by this module.

    - `NO_GLOBAL_RCS` option
       Instructs zsh to ignore all sub-sequent system-level configuration
       files. They contain configurations that we don't need and may conflict
       with our config.

    - `ZDOTDIR` variable
       Shows zsh where to find all other user-level zsh configuration files.

  zprofile
  --------

  Only runs at start for login shells. Use this for heavy environment setups or
  path configurations that don't need to re-run every time you open a new
  terminal tab.

  zshrc
  -----

  Runs everytime you open an interactive terminal window. Controls the
  interactive terminal user experience.

  Place all your prompt settings (e.g., Starship, Oh My Zsh), interactive
  options (setopt), completion setup (compinit), aliases, and custom functions
  here.

  zlogin
  ------

  Executes commands immediately after the shell environment is fully
  initialized, at login, immediately after `.zshrc`.

  Use for startup status messages, displaying system info (neofetch), or
  launching a window manager.

  zlogout
  -------

  Runs upon exiting a login shell. Used for clearing the terminal screen,
  dropping temporary files, or logging logout times.
*/
