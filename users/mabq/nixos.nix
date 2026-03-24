{ config, pkgs, lib, ... }:

{
  # Add `~/.local/bin` to PATH
  environment.localBinInPath = true;

  # Since we use ZSH as our shell
  programs.zsh = {
    enable = lib.mkDefault true;
    autosuggestions.enable = lib.mkDefault true;
    syntaxHighlighting.enable = lib.mkDefault true;
  };

  # Don't require password for sudo actions to wheel members
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  users.users.mabq = {
    isNormalUser = true;
    home = "/home/mabq";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ] # [1]
      ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]; # [2]
    # TODO: Missing the option to disallow imperative password changes
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01"; # [3]
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com" ];
  };
}

# ---
# [1] The `wheel` group is required to execute `sudo` actions without password.
#
# [2] If the docker service is enabled in the machine the user needs to be a
# member of the `docker` group to interact with the `docker` daemon (e.g. to
# start and stop container).
#
# (3) Use `mkpasswd -m sha-512` to create a passwork hash
# ------------------------------------------------------------------------------
