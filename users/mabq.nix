# Options inherent to this user only!
{ user, ... }:
{
  users.users.${user} = {
    # NixOS does not create a group after each user name, it groups all human
    # accounts into the `users` group.
    # group = "${user}";

    # Elevated privileges without password
    extraGroups = [ "wheel" ];

    # User account password
    #  The defaults module disables imperative changes, so this is the only way
    #  to set the user account password. For improved security, the default
    #  module also disables using account credentials for ssh authentication.
    #  Use `mkpasswd -m sha-512` to create a passwork hash.
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

    # Authorized ssh keys
    #  The public key should be included as an authorized key in all machines
    #  configured with this account. Yet, not all machines configured with this
    #  account should posses it's private key pair. You should be able to ssh
    #  into a server from your workstation, but not the other way around.
    #
    #  I now use Tailscale to log into remote machines and `gh` to authenticate
    #  to GitHub, so the private key file its rarely needed.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn"
    ];
  };
}
