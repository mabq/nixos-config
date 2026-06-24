{
  user,
  repoPath,
  ...
}:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          _7zz # Command line version of the 7-Zip archiver utility
          exiftool # Tool to read, write and edit EXIF meta information
          fd # Simple, fast and user-friendly alternative to find
          ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
          file # Program that shows the type of files
          fzf # Command-line fuzzy finder
          hyprpaper # Blazing fast wayland wallpaper utility
          imagemagick # Software suite to create, edit, compose, or convert bitmap images
          jq # Lightweight and flexible command-line JSON processor
          nerd-fonts.symbols-only # Just the Nerd Font Icons
          poppler # PDF rendering library
          resvg # SVG rendering library
          ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
          wl-clip-persist # Keep Wayland clipboard even after programs close
          wl-clipboard # Command-line copy/paste utilities for Wayland
          yazi # Blazing fast terminal file manager written in Rust, based on async I/O
          zoxide # Fast cd command that learns your habits
        ];

        file = {
          ".config/yazi/yazi.toml" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/yazi/yazi.toml";
            force = true;
          };
          ".config/yazi/init.lua" = {
            source = mkOutOfStoreSymlink "${repoPath}/config/yazi/init.lua";
            force = true;
          };
        };
      };
    };
}
