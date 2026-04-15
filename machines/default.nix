# This file contains default modules and configurations for all machines.
# Feel free to override any in each machine's config file.
{ config, lib, pkgs, machine, ...}:
with lib;
{
  imports = [
    ../modules/mySystem
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  # Use the latest stable linux kernel available in Nixpkgs
  boot.kernelPackages = mkDefault pkgs.linuxPackages_latest; # [1]

  environment.systemPackages = with pkgs; [
    age # Modern encryption tool with small explicit keys
    bat # Cat clone with syntax highlighting and Git integration
    caligula # User-friendly, lightweight TUI for disk imaging
    dnsutils # Domain name server
    fd # Simple, fast and user-friendly alternative to find
    gh # GitHub CLI tool
    git # Distributed version control system
    iperf # Tool to measure IP bandwidth using UDP or TCP
    just # Handy way to save and run project-specific commands
    ncdu # Disk usage analyzer with an ncurses interface
    ngrep # Network packet analyzer - use `sudo ngrep port <port>` to check if a port is being used
    neovim # Vim text editor fork focused on extensibility and agility
    nix-tree # Interactively browse a Nix store paths dependencies
    pciutils # Provides the `lspci` command
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    yazi # Blazing fast terminal file manager written in Rust, based on async I/O
  ];

  # i18n.defaultLocale = mkDefault "en_US.UTF-8";
 
  # Use the latest version of the `nix` CLI
  nix = {
    package = mkDefault pkgs.nixVersions.latest; # [2]
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = mkDefault true;

  # Default shell is per-user
  programs.zsh = {
    enable = mkDefault true;
    autosuggestions.enable = mkDefault true;
    syntaxHighlighting.enable = mkDefault true;
  };

  # ---

  # Enable the OpenSSH daemon (in case you ever lose Tailscale access).
  services.openssh = {
    enable = mkDefault true;
    settings = {
      PasswordAuthentication = mkDefault false;
      PermitRootLogin = mkDefault "no";
    };
  };

  # Enable Tailscale - must authenticate manually `sudo tailscale up`.
  services.tailscale.enable = mkDefault true;

  time.timeZone = mkDefault "America/Guayaquil";

  # ---

  # No sudo password for members of `wheel`.
  security.sudo.wheelNeedsPassword = mkDefault false;

  # No imperative changes of user accounts.
  users.mutableUsers = false;
}

# [1] https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L11
#     https://nixos.org/manual/nixos/unstable/#sec-kernel-config
#
# [2] https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L14
#     https://nixos.org/manual/nixos/unstable/#sec-kernel-config
