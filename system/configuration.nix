# Help:
#   https://search.nixos.org/options
#   https://mynixos.com/
#   `man configuration.nix`
#   `nixos-help`

{ config, lib, pkgs, c, ... }: {

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---

  # Define your hostname.
  networking.hostName = c.hostname;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Firewall. Open ports on per program file 🚩
  networking.firewall.enable = c.firewall;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # ---

  # Set your time zone.
  time.timeZone = c.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = c.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_EC.UTF-8";
    LC_IDENTIFICATION = "es_EC.UTF-8";
    LC_MEASUREMENT = "es_EC.UTF-8";
    LC_MONETARY = "es_EC.UTF-8";
    LC_NAME = "es_EC.UTF-8";
    LC_NUMERIC = "es_EC.UTF-8";
    LC_PAPER = "es_EC.UTF-8";
    LC_TELEPHONE = "es_EC.UTF-8";
    LC_TIME = "es_EC.UTF-8";
  };

  # ---

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.environment.systemPackages = with pkgs; [ ];

  # ---

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Use the latest possible version of nix provided by the version of the flake
  nix.package = pkgs.nixVersions.latest;

  # ---

  nixpkgs.hostPlatform = c.system;

  # Allow propietary packages?
  nixpkgs.config.allowUnfree = c.pkgsAllowUnfree;

  # List of allowed insecure packages
  nixpkgs.config.permittedInsecurePackages = c.pkgsInsecure;

  # ---

  # Replace user and group files on system activation. Don't forget to set the password with `passwd`. From Mitchell, do I need this 🚩
  # users.mutableUsers = false;

  # ---

  # Manage fonts. We pull these from a secret directory since most of these fonts require a purchase.
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [ jetbrains-mono ];

  # ---

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # ---

  # Enable the OpenSSH daemon. 🚩 Move to its own module
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Later, move to its own module. 🚩
  # services.flatpak.enable = true;

  # Later, move to its own module. 🚩
  # services.snap.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # ---

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular>
  # and is used to maintain compatibility with application data (e.g. databases) created>
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/sta>
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would>
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/>
  system.stateVersion = "25.05"; # Did you read the comment?
}
