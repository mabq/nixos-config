{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared-defaults.nix
    ../../modules/network/systemd-networkd.nix
  ];

  # 1. Force the kernel to power down the discrete GPU (dGPU)
  # 'apple_gmux.force_igp=1' tells the Mac to use Integrated Graphics
  boot.kernelParams = [ "apple_gmux.force_igp=1" "i915.lvds_channel=2" ];

  # 2. Prevent any Nvidia-related drivers from loading
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # 3. Explicitly use the Intel driver for the X server
  services.xserver.videoDrivers = [ "intel" ];

  # 4. Enable OpenGL for the Intel chip
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell+ (newer)
      intel-vaapi-driver # Better for your 2010 Ironlake graphics
      libvdpau-va-gl
    ];
  };

  # Force Wayland for specific toolkits
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1"; # Firefox Wayland
    NIXOS_OZONE_WL = "1";     # Chromium/Electron Wayland

    # Forces the use of the Intel driver for hardware acceleration
    WLR_NO_HARDWARE_CURSORS = "1"; 
    LIBVA_DRIVER_NAME = "i915";
  };

  environment.systemPackages = with pkgs; [
    virtualglLib
    kitty
  ];
 
  programs.hyprland.enable = true;

  # ---

  system.stateVersion = "25.11"; # [1]

  # [1] The installation version - used to maintain compatibility with
  # application data (e.g. databases) created on older NixOS versions.
  # The only time you should change this value is when re-installing NixOS
  # on this particular machine with a newer version of NixOS.
}
