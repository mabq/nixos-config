{ user, ... }:
{
  imports = [
    ../../modules/disko/uefi-ext4-encrypted.nix

    ../../modules/networkd.nix
    ../../modules/bluetooth.nix
    ../../modules/keyd.nix

    ../../modules/zsh.nix
    ../../modules/starship.nix
    ../../modules/tmux.nix
    ../../modules/yazi.nix
    ../../modules/btop.nix
    ../../modules/neovim.nix

    ../../modules/git.nix

    ../../modules/pipewire.nix
    ../../modules/foot.nix
    ../../modules/fonts.nix

    ../../modules/hyprland.nix
  ];
  # ----------------------------------------------------------------------------
  # NixOS
  # ----------------------------------------------------------------------------

  config = {

    # -- Machine ---------------------------------------------------------------

    disko.devices.disk.main.device = "/dev/sda";

    # Sometimes facter tries to use GRUB on UEFI systems, make sure it uses systemd-boot.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO

    # -- User ------------------------------------------------------------------

    users.users.${user} = {
      isNormalUser = true;

      home = "/home/${user}";

      # NixOS does not create a group after the user name, it groups all human
      # accounts into the `users` group.
      # group = "${user}";

      # Members of the `wheel` group can execute `sudo` without password.
      extraGroups = [ "wheel" ];

      # Use `mkpasswd -m sha-512` to create a passwork hash.
      hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

      # No need to check whether the service is enabled, if it is not the file exist without being used.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn"
      ];
    };

    # --------------------------------------------------------------------------
    # Home-manager
    # --------------------------------------------------------------------------

    home-manager.users.${user} =
      { pkgs, ... }:
      {
        home = {
          packages = with pkgs; [
            # CLI
            dropbox # Online stored folders (daemon version)
            age # Modern encryption tool with small explicit keys
            caligula # User-friendly, lightweight TUI for disk imaging
            fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
            gcc # GNU Compiler Collection
            iperf # Tool to measure IP bandwidth using UDP or TCP
            just # Handy way to save and run project-specific commands
            libreoffice-fresh # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
            mpv # General-purpose media player, fork of MPlayer and mplayer2
            ncdu # Disk usage analyzer with an ncurses interface
            nix-tree # Interactively browse a Nix store paths dependencies
            pciutils # Provides the `lspci` command
            qbittorrent # Featureful free software BitTorrent client
            tldr # Simplified and community-driven man pages
            unzip # Extraction utility for archives compressed in .zip format
            wget # Tool for retrieving files using HTTP, HTTPS, and FTP
            whois # Intelligent WHOIS client from Debian
            # GUI
            brave # Privacy-oriented browser for Desktop and Laptop computers
            # obs-studio # Free and open source software for video recording and live streaming
          ];
        };
      };
  };

}
