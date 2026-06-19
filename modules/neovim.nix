{
  user,
  repoPath,
  forceFiles,
  currentThemePath,
  ...
}:
{

  # ----------------------------------------------------------------------------

  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          neovim # Vim text editor fork

          tree-sitter # Parser generator tool and an incremental parsing library
          curl # Command line tool for transferring files with URL syntax (!Treesitter)
          gnutar # GNU implementation of the `tar` archiver (!Treesitter)

          fd # Simple, fast and user-friendly alternative to find (!Telescope find_files)
          ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep (!Telescope live_grep)
          gnumake # Tool to control the generation of non-source files from sources (!telescope fzf-native)

          lazygit # Simple terminal UI for git commands

          yazi # Blazing fast terminal file manager written in Rust, based on async I/O

          bash-language-server # Language server for Bash
          shfmt # Shell parser and formatter

          lua-language-server # Language server that offers Lua language support
          stylua # Opinionated Lua code formatter

          nixd # Feature-rich Nix language server interoperating with C++ nix
          nixfmt # Official formatter for Nix code

          biome # Toolchain of the web

          # luajit # High-performance JIT compiler for Lua 5.1
          # luarocks # A package manager for Lua modules
        ];

        file = forceFiles {
          ".config/nvim".source = mkOutOfStoreSymlink "${repoPath}/config/nvim";
          # Here we adding a symlink to the nvim directory, which is actually a
          # symlink to this same repository. This means that the file will
          # appear as changed right after executing a rebuild. To avoid that we
          # give it a very specific name in order to ignore it with `.gitignore`.
          # ".config/nvim/lua/plugins/nvim_theme_ignored.lua".source =
          #   mkOutOfStoreSymlink "${currentThemePath}/neovim.lua";
        };
      };
    };
}
