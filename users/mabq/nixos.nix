{ pkgs, inputs, user, ... }:

{
  # Add `~/.local/bin` to PATH
  environment.localBinInPath = true;

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ]; # (1)
    # TODO: passwd is taking precedence over this!
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01"; # (2)
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com" ];
  };
}

# ------------------------------------------------------------------------------
# (1)
# wheel - required to execute `sudo` actions without password
# networkmanager - required to activate wifi connections via `nmtui`
# docker - required to interact with the `docker` daemon (e.g. to start and stop container)
# ------------------------------------------------------------------------------
# (2)
# To create a new password hash use: `mkpasswd -m sha-512`
# ------------------------------------------------------------------------------
