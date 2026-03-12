{ pkgs, inputs, user, ... }:

{
  # add `~/.local/bin` to PATH
  environment.localBinInPath = true;

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    shell = pkgs.zsh;
    # wheel - no password for sudo actions
    # networkmanager - required to activate wifi connections via `nmtui`
    extraGroups = [ "wheel" "networkmanager" ];
    # `mkpasswd -m sha-512` - to create a password hash
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com" ];
  };
}
