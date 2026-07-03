{ user, ... }:
{
  home-manager.users.${user} =
    { pkgs, ... }:
    let
      tokyonightGtk = pkgs.tokyonight-gtk-theme.override {
        # See options here https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/to/tokyonight-gtk-theme/package.nix#L118
        colorVariants = [ "dark" ];
        sizeVariants = [ "standard" ];
        themeVariants = [ "default" ];
        tweakVariants = [ "moon" ];
        iconVariants = [ "Moon" ];
      };
    in
    {
      gtk = {
        enable = true;

        theme = {
          name = "Tokyonight-Dark-Moon"; # verify exact name — see step 2
          package = tokyonightGtk;
        };

        iconTheme = {
          name = "Tokyonight-Moon"; # verify exact name — see step 2
          package = tokyonightGtk;
        };
      };
    };
}
