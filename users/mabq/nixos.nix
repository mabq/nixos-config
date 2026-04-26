{ pkgs, lib, ... }:
with lib;
{
  # Add `~/.local/bin` to PATH
  environment.localBinInPath = true;

  programs.zsh.enable = mkDefault true;

  users.users.mabq = {
    isNormalUser = true;
    home = "/home/mabq";
    shell = pkgs.zsh;

    # Members of the `wheel` group can execute `sudo` without password.
    extraGroups = [ "wheel" ];

    # Use `mkpasswd -m sha-512` to create a passwork hash.
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

    # No need to check whether the service is enabled, if it is not the file exist without being used.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn" ];
  };
}

