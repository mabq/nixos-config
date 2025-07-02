# Tip:
#   In "MyNixOs" website search: `home-manager <program>` for home-manager configuration options.

{ inputs, c, ... }:

{ config, lib, pkgs, ... }: {

  # home.username = c.user;
  # home.homeDirectory = "/home/${c.user}";

  # Home-manager requires this be set - DO NOT TOUCH!
  home.stateVersion = "25.11";

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = with pkgs; [
    # _1password-cli
    # asciinema
    bat
    eza
    fd
    fzf
    # gh
    # htop
    # jq
    ripgrep
    # sentry-cli
    # erdtree
    # watch

    # gopls
    # zigpkgs."0.14.0"

    # claude-code
    # codex

    # Node is required for Copilot.vim
    # nodejs

    # chromium
    # firefox
    # rofi
    # valgrind
    # zathura
    # xfce.xfce4-terminal
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = c.locale;
    LC_CTYPE = c.locale;
    LC_ALL = c.locale;
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    # MANPAGER = "${manpager}/bin/manpager";

    # AMP_API_KEY = "op://Private/Amp_API/credential";
    # OPENAI_API_KEY = "op://Private/OpenAPI_Personal/credential";
  };
  # home.file = {
  #   ".gdbinit".source = ./gdbinit;
  #   ".inputrc".source = ./inputrc;
  # };

  # xdg.configFile = {
  #   "i3/config".text = builtins.readFile ./i3;
  #   "jj/config.toml".source = ./jujutsu.toml;
  #   "rofi/config.rasi".text = builtins.readFile ./rofi;
  #
  #   # tree-sitter parsers
  #   "nvim/parser/proto.so".source = "${pkgs.tree-sitter-proto}/parser";
  #   "nvim/queries/proto/folds.scm".source =
  #     "${sources.tree-sitter-proto}/queries/folds.scm";
  #   "nvim/queries/proto/highlights.scm".source =
  #     "${sources.tree-sitter-proto}/queries/highlights.scm";
  #   "nvim/queries/proto/textobjects.scm".source =
  #     ./textobjects.scm;
  #   "ghostty/config".text = builtins.readFile ./ghostty.linux;
  # };

  # Make cursor not tiny on HiDPI screens
  # home.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  #   x11.enable = true;
  # };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  # programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    # shellOptions = [];
    # historyControl = [ "ignoredups" "ignorespace" ];
    # initExtra = builtins.readFile ./bashrc;
    # shellAliases = shellAliases;
  };

  # programs.direnv= {
  #   enable = true;
  #
  #   config = {
  #     whitelist = {
  #       prefix= [
  #         "$HOME/code/go/src/github.com/hashicorp"
  #         "$HOME/code/go/src/github.com/mitchellh"
  #       ];
  #
  #       exact = ["$HOME/.envrc"];
  #     };
  #   };
  # };

  # programs.fish = {
  #   enable = true;
  #   shellAliases = shellAliases;
  #   interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" ([
  #     "source ${sources.theme-bobthefish}/functions/fish_prompt.fish"
  #     "source ${sources.theme-bobthefish}/functions/fish_right_prompt.fish"
  #     "source ${sources.theme-bobthefish}/functions/fish_title.fish"
  #     (builtins.readFile ./config.fish)
  #     "set -g SHELL ${pkgs.fish}/bin/fish"
  #   ]));
  #
  #   plugins = map (n: {
  #     name = n;
  #     src  = sources.${n};
  #   }) [
  #     "fish-fzf"
  #     "fish-foreign-env"
  #     "theme-bobthefish"
  #   ];
  # };

  programs.git = {
    enable = true;
    userName = "Alejandro Banderas";
    userEmail = "alejandro.banderas@me.com";
    # signing = {
    #   key = "523D5DC389D273BC";
    #   signByDefault = true;
    # };
    # aliases = {
    #   cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
    #   prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    #   root = "rev-parse --show-toplevel";
    # };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "mabq";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  # programs.go = {
  #   enable = true;
  #   goPath = "code/go";
  #   goPrivate = [ "github.com/mitchellh" "github.com/hashicorp" "rfc822.mx" ];
  # };

  # programs.jujutsu = {
  #   enable = true;
  #
  #   # I don't use "settings" because the path is wrong on macOS at
  #   # the time of writing this.
  # };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    # shortcut = "l";
    # secureSocket = false;
    # mouse = true;
    #
    # extraConfig = ''
    #   set -ga terminal-overrides ",*256col*:Tc"
    #   bind -n C-k send-keys "clear"\; send-keys "Enter"
    # '';
  };

  # programs.alacritty = {
  #   enable = !isWSL;
  #
  #   settings = {
  #     env.TERM = "xterm-256color";
  #
  #     key_bindings = [
  #       { key = "K"; mods = "Command"; chars = "ClearHistory"; }
  #       { key = "V"; mods = "Command"; action = "Paste"; }
  #       { key = "C"; mods = "Command"; action = "Copy"; }
  #       { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
  #       { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
  #       { key = "Subtract"; mods = "Command"; action = "DecreaseFontSize"; }
  #     ];
  #   };
  # };

  # programs.kitty = {
  #   enable = !isWSL;
  #   extraConfig = builtins.readFile ./kitty;
  # };

  # programs.i3status = {
  #   enable = true;
  #
  #   general = {
  #     colors = true;
  #     color_good = "#8C9440";
  #     color_bad = "#A54242";
  #     color_degraded = "#DE935F";
  #   };
  #
  #   modules = {
  #     ipv6.enable = false;
  #     "wireless _first_".enable = false;
  #     "battery all".enable = false;
  #   };
  # };

  programs.neovim = {
    enable = true;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    #
    # withPython3 = true;
    #
    # plugins = with pkgs; [
    #   customVim.vim-copilot
    #   customVim.vim-cue
    #   customVim.vim-fish
    #   customVim.vim-glsl
    #   customVim.vim-misc
    #   customVim.vim-pgsql
    #   customVim.vim-tla
    #   customVim.vim-zig
    #   customVim.pigeon
    #   customVim.AfterColors
    #
    #   customVim.vim-nord
    #   customVim.nvim-codecompanion
    #   customVim.nvim-comment
    #   customVim.nvim-conform
    #   customVim.nvim-dressing
    #   customVim.nvim-gitsigns
    #   customVim.nvim-lualine
    #   customVim.nvim-lspconfig
    #   customVim.nvim-nui
    #   customVim.nvim-plenary # required for telescope
    #   customVim.nvim-render-markdown
    #   customVim.nvim-telescope
    #   customVim.nvim-treesitter-context
    #
    #   vimPlugins.vim-eunuch
    #   vimPlugins.vim-markdown
    #   vimPlugins.vim-nix
    #   vimPlugins.typescript-vim
    #   vimPlugins.nvim-treesitter-parsers.elixir
    #   vimPlugins.nvim-treesitter
    #   vimPlugins.nvim-treesitter.withAllGrammars
    # ] ++ (lib.optionals (!isWSL) [
    #   # This is causing a segfaulting while building our installer
    #   # for WSL so just disable it for now. This is a pretty
    #   # unimportant plugin anyway.
    #   customVim.nvim-web-devicons
    # ]);
    #
    # extraConfig = (import ./vim-config.nix) { inherit sources; };
  };

  # programs.atuin = {
  #   enable = true;
  #   enableFishIntegration = true;
  #   enableNushellIntegration = true;
  #   settings = {
  #     show_tabs = false;
  #     style = "compact";
  #   };
  # };

  # programs.nushell = {
  #   enable = true;
  #   configFile.source = ./config.nu;
  #   shellAliases = shellAliases;
  #
  #   # This is appended at the end of the config file and we need to do
  #   # this to override OMP's transient prompt command.
  #   extraConfig = ''
  #     $env.TRANSIENT_PROMPT_COMMAND = null
  #   '';
  # };

  # programs.oh-my-posh = {
  #   enable = true;
  #   enableNushellIntegration = true;
  #   settings = builtins.fromJSON (builtins.readFile ./omp.json);
  # };

  #---------------------------------------------------------------------
  # Services
  #---------------------------------------------------------------------

  # services.gpg-agent = {
  #   enable = true;
  #   pinentry.package = pkgs.pinentry-tty;
  #
  #   # cache the keys forever so we don't get asked for a password
  #   defaultCacheTtl = 31536000;
  #   maxCacheTtl = 31536000;
  # };

  # xresources.extraConfig = builtins.readFile ./Xresources;
}
