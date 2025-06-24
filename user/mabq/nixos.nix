{ pkgs, inputs, c, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.${c.user} = {
    isNormalUser = true;
    home = "/home/${c.user}";
    extraGroups = [ "networkmanager" "wheel" ]; # Enable `sudo` for the user.
    shell = pkgs.fish;
    # use `mkpasswd -m sha-512` to generate a hashed password
    hashedPassword =
      "$6$7019/XiHypqK4Xyj$hALoKo3lWMhhZ3yeu0Cnmb3rINnULuOl3Oq.5nJ78x5tJBgDmZyiBxdO.5UwkGBGGKV1cSxCtCC4dwM/k9yQX0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
    ];
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # nixpkgs.overlays = import ../../lib/overlays.nix ++ [
  #   (import ./vim.nix { inherit inputs; })
  # ];
}
