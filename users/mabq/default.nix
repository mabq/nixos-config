{ inputs, user, ... }:
{
  imports = [
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

  # Decrypt secrets
  sops = {
    # Decrypted Age private key 🔥
    # Needs to be present before executing the flake. Without it sops-nix won't
    # be able to decrypt secrets and will throw an error. Make sure the
    # decrypted file never ends in a public repository and is only readable by
    # this user.
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    # The file containing the secrets.
    # Can only be edited with the `sops` command, which also expects to find
    # the private key above. If you ever change the location of this file,
    # update `.sops.yaml` at the root of the flake as well.
    defaultSopsFile = ./secrets.yaml;

    # Attribute names come from `secrets.yaml`
    secrets = {
      # Create the file with the decrypted content
      "ssh_private_key" = {
        path = "/home/${user}/.ssh/id_ed25519";
        mode = "0400";
        owner = "${user}";
        group = "users";
      };

      # Tailscale
      #  Decrypt the content into memory. When no `path` is given, sops-nix
      #  stores the decrypted file in `/run/secrets/<name>`. You can reference
      #  the path anywhere with `config.sops.secrets."<name>".path`
      "tailnetKey_mabqSharedTag" = { };
      "tailnetKey_mabqAdmin" = { };

      # Atuin - read the notes in the atuin module
      "atuin_key" = {
        path = "/home/${user}/.local/share/atuin/key";
        mode = "0600";
        owner = "${user}";
        group = "users";
      };
    };
  };
}
