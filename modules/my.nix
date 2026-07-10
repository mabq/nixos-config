{ lib, ... }:
let
  # Make sure the string you pass to the `default.theme` option matches one of the
  # directory names in `/themes`.
  #   1. `builtins.readDir` returns an attribute set like:
  #       { catppuccin = "directory"; nord = "directory"; }
  #   2. `filterAttrs` filters out anything that is not a directory (just in case).
  #   3. `attrNames` extracts just the keys into a list:
  #       [ "catppuccin" "nord" "gruvbox" ]
  validThemes = builtins.attrNames (
    lib.attrsets.filterAttrs (key: value: value == "directory") builtins.readDir ../themes
  );
in
{
  options = {
    my = {
      default = {
        theme = lib.mkOption {
          # Restrict the option to ONLY accept a valid theme
          type = lib.types.enum validThemes;
          default = "catppuccin";
          description = ''
            Global theme.
            The string value must match an existing folder name inside the `/themes` directory.
            Currently available options: ${lib.strings.concatStringsSep ", " validThemes}
          '';
        };
      };
    };
  };
}
