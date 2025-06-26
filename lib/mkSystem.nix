{ nixpkgs, nixpkgs-unstable, home-manager, inputs }:

id:

let
  c = import ./mkConfigAttrs.nix id;

  systemConfig = ../system/${id};
  userOSConfig = ../user/${c.user}/nixos.nix;
  userHMConfig = ../user/${c.user}/home-manager.nix;

in nixpkgs.lib.nixosSystem rec {
  system = c.system;

  modules = [
    {
      # expose to all modules as arguments
      config._module.args = {
        c = c;
        nixpkgs-unstable = nixpkgs-unstable;
        inputs = inputs;
      };
    }
    systemConfig
    userOSConfig
    home-manager.nixosModules.home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.users.${c.user} = userHMConfig;
    }
  ];
}
