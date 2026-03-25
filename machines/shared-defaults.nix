# This file contains default modules and configurations for all machines.
# Feel free to override any in each machine's config file.
{ config, lib, pkgs, ...}:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Use the latest stable linux kernel available in Nixpkgs
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # [1]

  environment.systemPackages = with pkgs; [
    age
    bat
    gh
    git
    ncdu
    ngrep # A grep-like utility that allows you to search for network packets on an interface
    neovim
    ripgrep
    yazi
  ];

  networking.firewall.enable = lib.mkDefault true;

  # i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
 
  # Use the latest version of the `nix` CLI
  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest; # [2]
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Default shell is per-user
  programs.zsh = {
    enable = lib.mkDefault true;
    autosuggestions.enable = lib.mkDefault true;
    syntaxHighlighting.enable = lib.mkDefault true;
  };

  # Don't require password for sudo to members of the `wheel` group.
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      # TODO: Should I just enable access with SSH key?
      PasswordAuthentication = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "no";
    };
  };

  services.tailscale.enable = lib.mkDefault true; # [3]

  time.timeZone = lib.mkDefault "America/Guayaquil";

  # Do not allow to change users with imperative commands. Make sure you set
  # the root password on installation and normal users passwords with hashes.
  users.mutableUsers = false;
}

# [1]
# [Hashimoto](https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L11)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/#sec-kernel-config)
#
# [2]
# [Hashimoto](https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L14)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/#sec-kernel-config)
#
# [3] Manually authenticate with `sudo tailscale up`.
