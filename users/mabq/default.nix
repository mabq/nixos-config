{ pkgs, user, ... }:
{
  imports = [
    ./secrets/sops-nix.nix
  ];

  users.users.${user} = {
    # NixOS does not create a group after each user name, it groups all human
    # accounts into the `users` group.
    # group = "${user}";

    # No sudo password for members of `wheel`
    extraGroups = [ "wheel" ];

    # Use `mkpasswd -m sha-512` to create a passwork hash.
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn"
    ];
  };

  # Packages the user expects to find in all systems
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # CLI
      pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
      caligula # User-friendly, lightweight TUI for disk imaging
      psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    ];
  };
}
