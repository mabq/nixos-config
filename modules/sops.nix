# Read sops notes in obsidian!
{
  pkgs,
  inputs,
  user,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  home-manager = {
    users.${user}.home.packages = with pkgs; [
      sops # Simple and flexible tool for managing secrets
      age # Modern encryption tool with small explicit keys
    ];
  };

  sops = {
    # Point sops-nix to your encrypted file and host SSH key
    defaultSopsFile = ../secrets/${user}.yaml;

    # Specify the path to your standalone age private key
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

    secrets.tailscale_auth_key = { };
  };
}
