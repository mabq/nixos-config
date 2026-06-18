{ lib, pkgs, ... }: {
  imports = [
    ./all.nix
    ../modules/disko-uefi-ext4-encrypted.nix
    ../modules/keyd.nix
    ../modules/network-networkd.nix
    ../modules/pipewire.nix
  ];

  # Sometimes facter tries to use GRUB on UEFI systems, make sure it uses systemd-boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---

  # 1. Force the kernel to use Intel graphics and block Nvidia drivers
  boot.kernelParams = [
    "i915.lvds_channel_mode=1"
    "nouveau.modeset=0"
  ];

  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
  ];

  # 2. Set X11/Wayland to use the Intel driver explicitly
  services.xserver.videoDrivers = [ "modesetting" ];

  # 3. Hardware acceleration for Intel HD Graphics (Ironlake generation)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # ---

  system.stateVersion = "25.11"; # only update when reinstalling with a newer ISO
}
