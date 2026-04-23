{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # 1
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # 2
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    # overlays = []; # 3
    mkSystem = import ./lib/mksystem.nix { inherit nixpkgs home-manager inputs; };
  in {
    nixosConfigurations = {
      macbook = mkSystem { # 4
        machine = "macbook"; # 5
        user = "mabq";
      };
      xps = mkSystem {
        machine = "xps";
        user = "mabq";
      };
    };
  };
}

# 1. Or use `nixos-XX.YY` for stable releases.
#
# 2. Override home-manager's nixpkgs version with our version. Not all flakes
# expect this change but home-manager does.
#
# 3. Only use overlays to correct bugs in packages being used by other
# packages. For upgrading/downgrading specific packages always prefer multiple
# nixpkgs inputs - lighter and no compilation from source required.
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
#
# 4. NixOS configuration name - cannot be accessed in NixOS modules.
#
# 5. Machine configuration name - can be accessed in NixOS modules via
# special arguments. Use the same name as the NixOS configuration name - this
# will be set as the default hostname and `nixos-rebuild` command uses the
# hostname when no NixOS configuration name is passed.
