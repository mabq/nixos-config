{ overlays, nixpkgs, inputs }:

id:

let
  c = import ./mkConfigAttrs.nix id;

  systemConfig = ../system/${id};
  userOSConfig = ../user/${c.user}/nixos.nix;
  userHMConfig = ../user/${c.user}/home-manager.nix;

in nixpkgs.lib.nixosSystem rec {
  system = c.system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    systemConfig
    userOSConfig
    inputs.home-manager.nixosModules.home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.users.${c.user} = import userHMConfig { inherit inputs c; };
    }

    # Expose some extra arguments so that our modules can parameterize better
    # based on these values.
    { config._module.args = { inherit c inputs; }; }
  ];
}
