{config, lib, pkgs, ...}:

{
  time.timeZone = "America/Guayaquil";

  users.users.mabq = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  services.openssh.enable = lib.mkDefault true;

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
