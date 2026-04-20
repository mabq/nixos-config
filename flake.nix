{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # [1]
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # [2]
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    overlays = [];
    mkSystem = import ./lib/mksystem.nix { inherit overlays nixpkgs inputs; };
  in {
    nixosConfigurations = {
      macbook = mkSystem { # [3]
        machine = "macbook"; # [4]
        user = "mabq";
      };
      xps = mkSystem {
        machine = "xps";
        user = "mabq";
      };
    };
  };
}

# [1] Use `nixos-25.11` for stable releases.
#
# [2] Override home-manager's nixpkgs version with our version. Not all flakes
# expect this change but home-manager does.
#
# [3] NixOS configuration name - cannot be accessed in NixOS modules.
#
# [4] Machine configuration name - can be accessed in NixOS modules via
# special arguments. Use the same name as the NixOS configuration name - this
# will be set as the default hostname and `nixos-rebuild` command uses the
# hostname when no NixOS configuration name is passed.
