{ ... }:
let

in
{
  imports = [
    ../modules/disko/uefi-ext4-encrypted.nix
    ../modules/defaults/nixos.nix
  ];

}
