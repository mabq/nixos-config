{config, lib, pkgs, machine, ...}:

{
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    age
    git
    neovim
  ];

  networking.networkmanager.enable = lib.mkDefault true;
  networking.hostName = lib.mkDefault "${machine}";

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

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  time.timeZone = lib.mkDefault "America/Guayaquil";
}
