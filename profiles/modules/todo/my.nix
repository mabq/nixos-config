{ config, lib, ... }:
let
  validCompositorNames = [
    "hyprland"
    "niri"
  ];

  validThemeNames = builtins.attrNames (
    lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ../themes)
  );
in
{
  options = {
    my.theme = lib.mkOption {
      # Must be a string matching a directory name in `/themes`
      type = lib.types.enum validThemeNames;
      default = "catppuccin";
      description = ''
        Must be one of: ${lib.strings.concatStringsSep ", " validThemeNames}
      '';
    };

    my.compositor = lib.mkOption {
      # Must be `null` or one of the compositors above
      type = lib.types.nullOr (lib.types.enum validCompositorNames);
      default = "hyprland";
      description = ''
        Must be one of: ${lib.strings.concatStringsSep ", " validCompositorNames}
      '';
    };

    my._isDesktop = lib.mkOption {
      type = lib.types.bool;
      default = config.my.compository != null;
      readOnly = true;
      description = ''
        Read only option to check if desktop programs should be installed.
      '';
    };

  };
}

/*
  validThemeNames [1]:

    A list of valid theme names to pass to the option.

    First, `builtins.readDir` reads the contents of the `/themes` directory
    and returns an attribute set like:
      `{ catppuccin = "directory"; nord = "directory"; }`

    Just in case, `filterAttrs` gets rid of anything whose value is not
    "directory".

    Finally, `attrNames` extracts only the keys, returning a list like:
      `["catppuccin" "nord" "gruvbox"]`

    `lib.types.enum` makes sure the string you pass to the option matches
    one of the theme directory names. Throws a build error otherwise.
*/
