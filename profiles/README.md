
- Modules are grouped using the same categories used by the NixOS repository.
  https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/module-list.nix

- Try to keep each module as isolated as possible. For example:
  - Even though we have a foot module, the wayland compositor module should
    at also install it because thats the default terminal and its required
    by its config files.
  - Zsh config files must always check if an executable is available before
    trying to initialize it or set aliases to it.
  - And so on...
