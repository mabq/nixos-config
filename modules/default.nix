{ ... }: {
  imports = [
    # TODO: This must be split into modules (networking, hardware, etc.)
    ./nixos-defaults.nix

    ./my
    ./desktop
  ];
}
