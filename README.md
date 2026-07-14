# nixos-config ❄️

The purpose of this repo is to produce a set of NixOS reproducible configurations and be able to apply any of them on any machine with a single command (even remotely).

  > IMPORTANT!
    Files referenced by Nix must be tracked by Git, otherwise the build fails.


## Installation

Use [nixos-anywhere](./notes/installation-nixos-anywhere.md) to build a new (remote) machine with a single command or do a [manual installation](./notes/installation-manual.md) and apply one of the configurations later.

--


- [Top level options vs. custom module options]()
  Much simpler approach. All options in a top level file that make conditional imports possible, with custom module options you have to import everything and control execution with `mkIf config.<custom>.<option>.enable`.

  Options are passed to every single nixos and home-manager module.

## flake.nix

Produces a set of nixos configurations (these are your profiles!).

The name of the configuration is what you use to build the system.

You can customize each configuration with a set of options (see `lib/mkSystem.nix`)


## Notes
--------

- [Guidelines](./notes/guidelines.md)
- [NixOS Git Analogy](./notes/nixos-git-analogy.md)


