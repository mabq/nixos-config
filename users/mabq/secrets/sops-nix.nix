# Open user secrets
{ inputs, user, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Age keys 🔥
    #  Sops secrets are encrypted/decrypted using age's public/private keys.
    #  These keys are expected to be found in the file below — before you
    #  attempt to build the flake, ensure the decrypted keys file is there.
    #  This directory contains an encrypted version of the keys file, all
    #  you need to do is decrypt it in the expected path.
    #  BE CAREFUL NOT TO INCLUDE THE DECRYPTED FILE IN ANY REPOSITORY!
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    # Secrets file
    #  Can only be edited with the `sops` command (requires age keys file to be
    #  in place). If you ever change the location of this file you will need to
    #  update the path referencing the keys file in `.sops.yaml` at the root of
    #  the flake.
    defaultSopsFile = ./secrets.yaml;

    # Open secrets
    #  Attribute names match the secrets in `secrets.yaml`.
    #
    #  Sops-nix creates a file in memory (`/run/secrets/<secret>`) for each
    #  secret. You can optionally use the following attributes for each secret:
    #    - `path` — create a symlink to the secret file in the given path.
    #    - `owner` — to change the owner of the secret file.
    #
    #  If you need to reference the secret file in a nix option in another
    #  module, use `config.sops.secrets.<name>.path`.
    secrets = {

      # SSH key
      #  Creates a symlink to the secret file in the expected location. SSH
      #  requires the private key file to only be readable by the user.
      "ssh_private_key" = {
        path = "/home/${user}/.ssh/id_ed25519";
        mode = "0400";
        owner = "${user}";
        group = "users";
      };

      # Tailscale
      #  This user owns the Tailnet, so he owns the authentication keys allowed
      #  in that Tailnet.
      #
      #  Which key is used depends on the profile, not the user. For example; a
      #  server should use a tag key, a work station should use an admin key.
      #
      #  No need to create symlinks, these keys are used in profile files in
      #  nix options.
      #
      #  For more information see:
      #   https://tailscale.com/docs/features/access-control/auth-keys
      #   https://tailscale.com/docs/how-to/set-up-servers
      "mabqTailnet_sharedTagKey" = { };
      # "mabqTailnet_AdminKey" = { };

      # Atuin
      #  Read the notes in the atuin module
      "atuin_key" = {
        path = "/home/${user}/.local/share/atuin/key";
        mode = "0600";
        owner = "${user}";
        group = "users";
      };

    };
  };
}
