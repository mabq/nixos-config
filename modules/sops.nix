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
    # inputs.sops-nix.homeManagerModules.sops
  ];

  home-manager = {
    users.${user}.home.packages = with pkgs; [
      sops # Simple and flexible tool for managing secrets
      age # Modern encryption tool with small explicit keys
    ];
  };

  sops = {
    defaultSopsFile = ../secrets/${user}.yaml;
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    secrets = {
      tailscale_auth_key = { };
    };
  };
}
