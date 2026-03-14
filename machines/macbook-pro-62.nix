{ machine, ...}:

{
  imports = [
    ./hardware/${machine}.nix
    ./defaults.nix
  ];

  services.openssh.enable = false;

  # Enable CUPS to print documents
  # services.printing.enable = true;

  # --------------------------------------------------------------------------------

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application data
  # (e.g. databases) created on older NixOS versions.
  #
  # The only time you should change this value is when re-installing NixOS in this
  # particular machine with a newer version than the one specified here. Do not
  # change this value under any other circumstance.
  system.stateVersion = "25.11"; # Did you read the comment?
}
