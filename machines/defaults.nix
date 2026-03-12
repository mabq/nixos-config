{config, lib, pkgs, machine, ...}:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Use the latest stable linux kernel available in Nixpkgs
  boot.kernelPackages = pkgs.linuxPackages_latest; # (1)

  environment.systemPackages = with pkgs; [
    age
    git
    neovim
    yazi
  ];

  # i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  networking.networkmanager.enable = lib.mkDefault true;

  networking.hostName = lib.mkDefault "${machine}";

  # Use the latest version of the `nix` CLI
  nix.package = lib.mkDefault pkgs.nixVersions.latest; # (2)

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Must enable default shell
  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.autosuggestions.enable = lib.mkDefault true;
  programs.zsh.syntaxHighlighting.enable = lib.mkDefault true;

  # Enable the OpenSSH daemon
  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PasswordAuthentication = lib.mkDefault true;
  services.openssh.settings.PermitRootLogin = lib.mkDefault "no";

  services.pipewire.enable = lib.mkDefault true;
  services.pipewire.pulse.enable = lib.mkDefault true;

  # Don't require password for sudo actions to wheel members
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  time.timeZone = lib.mkDefault "America/Guayaquil";

  # Virtualization settings
  virtualisation.docker.enable = lib.mkDefault true;
}

# -----------------------------------------------------------------------------
# (1)
# [Hashimoto](https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L11)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/#sec-kernel-config)
# -----------------------------------------------------------------------------
# (2)
# [Hashimoto](https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L14)
# [NixOS Manual](https://nixos.org/manual/nixos/unstable/#sec-kernel-config)
# -----------------------------------------------------------------------------
