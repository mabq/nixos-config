# Installation with nixos-anywhere

[nixos-anywhere](https://github.com/nix-community/nixos-anywhere) allows you to install NixOS and apply one of the configurations on a **remote** machine with a single command from the source machine.

Before trying this, make sure both machines meet the [prerequisites](https://github.com/nix-community/nixos-anywhere#prerequisites).

---
- [Obtaining NixOS](https://nixos.org/manual/nixos/stable/#sec-obtaining)
- [Booting from the Install Medium](https://nixos.org/manual/nixos/stable/#sec-installation-booting)
---

## Instructions
---------------

1. Boot the target machine from a USB flash drive:

   > INFO: Skip this step if the target machine is already running Linux

   [Download](https://nixos.org/download) the *minimal* ISO image and execute the following command to create the bootable USB:

   > WARNING: This command completely destroys the data on the given disk, make sure you use the correct block device!. Double check with `lsblk` or use `caligula` (if available on your system).

   ```bash
   # Replace:
   #   `if` (input file) with the path of the ISO image.
   #   `of` (output file) with the correct disk descriptor.
   sudo dd bs=4M conv=fsync oflag=direct status=progress if=<PATH-TO-IMAGE> of=/dev/<DISK>
   ```

2. Verify access to the remote machine:

   For the installation command to succeed, you either need `root` credentials or be able to escalate privileges without being prompted for a password.

   If the target machine was booted from a USB, just login as root using `sudo -i` and change its password with `passwd`.

   If you don't have `root` credentials, ssh into the machine `ssh <USER>@ip` and execute `sudo ls` to verify if a password is required to elevate privileges.

   Finally, run `ip a` and annotate the IP.

3. Install NixOS in the target machine from the source machine:

   Clone this repository (doesn't matter where) and `cd` into it.

   If the configuration you want to apply is not on the `master` branch, make sure you `git checkout <branch>` the desired branch first.

   Finally, execute the following command:

   > WARNING: This command completely destroys the data on the remote machine, make sure you use the correct IP!

   ```bash
   # Replace:
   #   `NIXOS-CONFIGURATION-NAME` with one of the nixos configurations produced by the flake.
   #   `MACHINE-NAME` with one of the machines in the `/machines` directory.
   #   `USER` with `root` or the username (must be able to execute `sudo` without password).
   #   `IP` with the ip of the target machine.
   sudo \
     # Experimental features must be enabled to run this command
     nix --experimental-features "nix-command flakes" \
     # Runs nixos-anywhere code directly from the repository (awesome)
     run github:nix-community/nixos-anywhere -- \
     # Uses the given configuration name (pick one) of the flake in the CWD.
     --flake ".#<NIXOS-CONFIGURATION-NAME>" \
     #
     --generate-hardware-config nixos-facter ./machines/<MACHINE-NAME>/facter.json \
     --target-host <USER>@<IP> \
     --show-trace
   ```

For more information see [nixos-anywhere](https://nix-community.github.io/nixos-anywhere) and [disko](https://github.com/nix-community/disko).

