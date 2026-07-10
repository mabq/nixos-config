{ lib, ... }:
let
  # Make sure the string you pass to the `default.theme` option matches one of the
  # directory names in `/themes`.
  #   `builtins.readDir` returns an attribute set like: { catppuccin = "directory"; nord = "directory"; }
  themeDirContents = builtins.readDir ../themes;
  #   `attrNames` extracts just the keys into a list: [ "catppuccin" "nord" "gruvbox" ]
  validThemes = builtins.attrNames (
    # `filterAttrs` filters out anything that is not a directory (just in case).
    lib.attrsets.filterAttrs (name: type: type == "directory") themeDirContents
  );
in
{
  options = {
    my.theme = lib.mkOption {
      # Restrict the option to only accept a valid theme
      type = lib.types.enum validThemes;
      default = "catppuccin";
      description = ''
        Global theme.
        The string value must match an existing folder name inside the `/themes` directory.
        Currently available options: ${lib.strings.concatStringsSep ", " validThemes}
      '';
    };

    my.desktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Used to activate modules that are only required on desktop environments.
      '';
    };

  };
}
