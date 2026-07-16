{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sdX"; # Replace with disk
    enableCryptodisk = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "America/Guayaquil";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.mabq = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      tmux
      neovim
      gh
      git
      lazygit
      yazi
    ];
  };

  services.openssh.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
