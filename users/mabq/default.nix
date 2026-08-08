{
  config,
  inputs,
  user,
  ...
}:
{
  imports = [
    # inputs.sops-nix.nixosModules.sops
    inputs.sops-nix.nixosModules.sops
  ];

  users.users.${user} = {
    # NixOS does not create a group after each user name, it groups all human
    # accounts into the `users` group.
    # group = "${user}";

    # No sudo password for members of `wheel`
    extraGroups = [ "wheel" ];

    # Use `mkpasswd -m sha-512` to create a passwork hash.
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn"
    ];
  };

  sops = {
    # ⚠️ IMPORTANT! This file needs to be present before executing the flake.
    # It contains the private key required to decrypt user secrets. Make sure
    # it never ends in a public repository and is only readable by this user.
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    # The file containing the secrets. Can only be edited with the `sops`
    # command, which also expects to find the private key in the path above.
    defaultSopsFile = ./secrets.yaml;

    secrets = {
      "tailscale_auth_key" = {
        # path = "";
        # When no explicit `path` is set, sops-nix places the decrypted file in
        # `/run/secrets/<name>` (a RAM-backed tmpfs). You can reference the
        # path dynamically anywhere in your configuration with
        # `config.sops.secrets."name".path` (see below).
      };
      "ssh_private_key" = {
        # Create the file with the right permissions
        path = "/home/${user}/.ssh/id_ed25519";
        mode = "0400";
        owner = "${user}";
        group = "users";
      };
    };
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."tailscale_auth_key".path;
    extraUpFlags = [
      # up — https://tailscale.com/docs/reference/tailscale-cli#up
      "--hostname=${config.networking.hostName}" # magic-dns name
      # These settings are secure since we own the Tailnet, do not
      # enable these for Tailnets you do not own.
      "--accept-dns"
      "--accept-routes"
      "--ssh"
    ];
    extraSetFlags = [
      # set — https://tailscale.com/docs/reference/tailscale-cli#set
    ];
  };

}
