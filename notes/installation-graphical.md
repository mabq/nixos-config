# Graphical installation

Create a bootable USB with the Graphical ISO image. Follow the instructions in [Obtaining NixOS](https://nixos.org/manual/nixos/stable/#sec-obtaining).

Boot from the USB and follow the steps of the graphical installer. For more information see [Graphical Installation](https://nixos.org/manual/nixos/stable/#sec-installation-graphical).

---

Flakes do not allow the usage of files outside the flake repo.

If you want to use the flake, somehow you would need to clone the repository. Move `/etc/nixos/hardware-configuration.nix` to `<repo>/hardware-configuration`

Use any method to move the content of the hardware-configuration file to the nixos-config repository.


