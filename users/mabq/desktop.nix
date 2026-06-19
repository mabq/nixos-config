{ user, ... }:
{
  imports = [
    ../../modules/networkd.nix
    ../../modules/pipewire.nix
    ../../modules/keyd.nix

    ../../modules/zsh.nix
    ../../modules/starship.nix
    ../../modules/tmux.nix
    ../../modules/yazi.nix
    ../../modules/btop.nix
    ../../modules/neovim.nix

    ../../modules/git.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true; # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm
  };

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";

    # Members of the `wheel` group can execute `sudo` without password.
    extraGroups = [ "wheel" ];

    # Use `mkpasswd -m sha-512` to create a passwork hash.
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

    # No need to check whether the service is enabled, if it is not the file exist without being used.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn"
    ];
  };

  home-manager.users.${user} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # CLI
        age # Modern encryption tool with small explicit keys
        caligula # User-friendly, lightweight TUI for disk imaging
        fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
        gcc # GNU Compiler Collection
        iperf # Tool to measure IP bandwidth using UDP or TCP
        just # Handy way to save and run project-specific commands
        mpv # General-purpose media player, fork of MPlayer and mplayer2
        ncdu # Disk usage analyzer with an ncurses interface
        nix-tree # Interactively browse a Nix store paths dependencies
        pciutils # Provides the `lspci` command
        tldr # Simplified and community-driven man pages
        unzip # Extraction utility for archives compressed in .zip format
        wget # Tool for retrieving files using HTTP, HTTPS, and FTP
        whois # Intelligent WHOIS client from Debian
        # -- GUI ---------------------------------------------------------------
      ];
    };
}
