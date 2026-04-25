{ config, lib, pkgs, machine, user, ... }:

with lib;

{
  imports = [
    # On each machine config file enable one of these or leave them disable
    # for automatic DHCP configuration by facter.
    ../modules/mySystem/network/networkd.nix
    ../modules/mySystem/network/networkmanager.nix
  ];

  boot = {
    # Use the latest stable linux kernel available in Nixpkgs
    kernelPackages = mkDefault pkgs.linuxPackages_latest; # 1
    loader = {
      # Limit the number of generations to keep
      systemd-boot.configurationLimit = mkIf config.boot.loader.systemd-boot.enable (mkDefault 10);
      grub.configurationLimit = mkIf config.boot.loader.grub.enable (mkDefault 10);
    };
  };

  environment.systemPackages = with pkgs; [
    # age # Modern encryption tool with small explicit keys
    # caligula # User-friendly, lightweight TUI for disk imaging
    # dnsutils # Domain name server - provides the `dig` command
    # iperf # Tool to measure IP bandwidth using UDP or TCP
    # ngrep # Network packet analyzer - use `sudo ngrep port <port>` to check if a port is being used
    # pciutils # Provides the `lspci` command
    bat # Cat clone with syntax highlighting and Git integration
    btop # Monitor of resources
    fd # Simple, fast and user-friendly alternative to find
    fzf # Command-line fuzzy finder written in Go
    gh # GitHub CLI tool
    git # Distributed version control system
    just # Handy way to save and run project-specific commands
    ncdu # Disk usage analyzer with an ncurses interface
    neovim # Vim text editor fork focused on extensibility and agility
    nix-tree # Interactively browse a Nix store paths dependencies
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    tldr # Simplified and community-driven man pages
    tmux # Termianl multiplexer
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    yazi # Blazing fast terminal file manager written in Rust, based on async I/O
  ]
  ++ optionals config.hardware.bluetooth.enable [
    # NOTE: If you cannot connect Sony's Headphones is because the pipewire
    # user services has not initiated. The user session must be initiated for
    # the pipewire's user units to be triggered.
    bluetui # TUI for managing bluetooth on Linux
  ]
  ++ optionals config.services.pipewire.enable [
    wiremix # Simple TUI mixer for PipeWire
  ];

  hardware.bluetooth.enable = mkDefault true;

  hardware.facter.reportPath = ./${machine}/facter.json;

  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  networking = {
    hostName = mkDefault machine;
    firewall.enable = mkDefault true;
  };

  # Use the latest version of the `nix` CLI
  nix = {
    package = mkDefault pkgs.nixVersions.latest; # 2
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = mkDefault true; # 3
    };
    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 15d";
    };
  };

  nixpkgs.config.allowUnfree = mkDefault true;

  # Default shell is per-user
  programs.zsh = {
    enable = mkDefault true;
    autosuggestions.enable = mkDefault true;
    syntaxHighlighting.enable = mkDefault true;
  };

  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 8 * 1024; # NixOS expects size in MB
  #   priority = 5; # Lower priority than zram
  # }];

  # Required by pipewire
  security.rtkit.enable = mkIf config.services.pipewire.enable true;

  # No sudo password for members of `wheel`
  security.sudo.wheelNeedsPassword = mkDefault false;

  # Enable the OpenSSH daemon (in case you ever lose Tailscale access)
  services.openssh = {
    enable = mkDefault true;
    settings = {
      PasswordAuthentication = mkDefault false;
      PermitRootLogin = mkDefault "no";
    };
  };

  # Enable Tailscale - must authenticate manually `sudo tailscale up`
  services.tailscale.enable = mkDefault true;

  services.pipewire = {
    enable = mkDefault true;
    alsa.enable = mkDefault true;
    jack.enable = mkDefault true;
    pulse.enable = mkDefault true;
  };

  time.timeZone = mkDefault "America/Guayaquil";

  # No imperative changes of user accounts.
  users.mutableUsers = mkDefault false;

  users.users.${user}.extraGroups = [ ]
    ++ optionals config.virtualisation.docker.enable [ "docker" ];

  virtualisation.docker.enable = mkDefault false;

  zramSwap = {
    enable = mkDefault true;
    memoryPercent = mkDefault 50;
    algorithm = mkDefault "lz4"; # On machines with newer CPUs use `zstd` for higher compression rates.
    priority = 100; # Use zram before swap file
  };
}

# [1] https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L11
#     https://nixos.org/manual/nixos/unstable/#sec-kernel-config
#
# [2] https://github.com/mitchellh/nixos-config/blob/0c42252d8951ac338fe9d80d45ea912e0b956993/machines/vm-shared.nix#L14
#     https://nixos.org/manual/nixos/unstable/#sec-kernel-config
#
# [3] Optimize storage
#     You can also manually optimize the store via: `nix-store --optimise`.
#     Refer to the following link for more details: https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
#
# About mkDefault, mkForce and mkOverride - https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration#lib-mkoverride-lib-mkdefault-and-lib-mkforce
