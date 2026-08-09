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
    # IMPORTANT!
    # This file needs to be present before executing the flake. It should
    # contain the decrypted version of `./keys.txt.age`. Without this file in
    # place sops-nix won't be able to decrypt secrets and will throw an error.
    # Make sure this file never ends in a public repository and is only
    # readable by this user.
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    # The file containing the secrets. Can only be edited with the `sops`
    # command, which also expects to find the private key above.
    # If you ever change the location of this file, update `.sops.yaml` at the
    # root of the flake.
    defaultSopsFile = ./secrets.yaml;

    # Decrypt secrets. Secret names must match the ones in the secrets file.
    secrets = {
      # HERE!!! The mabq.github tailnet is owned by me so only I should be
      # able to decrypt the auth keys.
      "mabq_tailscale_sharedTag_authKey" = {
        # path = "";
        # When no explicit `path` is set, sops-nix places the decrypted file in
        # `/run/secrets/<name>` (a RAM-backed tmpfs). You can reference the
        # path dynamically anywhere with `config.sops.secrets."<name>".path`.
      };
      "mabq_ssh_private_key" = {
        # Create the file with the right permissions
        path = "/home/${user}/.ssh/id_ed25519";
        mode = "0400";
        owner = "${user}";
        group = "users";
      };
    };
  };
}
