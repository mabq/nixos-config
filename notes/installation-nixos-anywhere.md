# Installation with nixos-anywhere

[nixos-anywhere](https://github.com/nix-community/nixos-anywhere) allows you to install NixOS and apply one of the configurations on a **remote** machine with a single command from the source machine.

Before trying this, make sure both machines meet the [prerequisites](https://github.com/nix-community/nixos-anywhere#prerequisites).


## Instructions
---------------

1. Boot the target machine from the USB (skip if it is already running Linux):

   [Download](https://nixos.org/download) the *minimal* ISO image and execute the following command to create the bootable USB:

   > WARNING: This command completely destroys the data on the given disk, make sure you use the correct block device!. Double check with `lsblk`.

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

3. Install NixOS from the source machine:

   Clone this repository whereever you want and `cd` into it.

   Run the following command to generate a `facter.json` report of the target machine and automatically install NixOS and apply the given configuration:

   > WARNING: This command completely destroys the data on the remote machine, make sure you use the correct IP!

   ```bash
   # Replace:
   #   `NIXOS-CONFIGURATION-NAME` with one of the nixos configurations produced by the flake.
   #   `MACHINE-NAME` with one of the machines in the `/machines` directory.
   #   `USER` with `root` or the username (must be able to execute `sudo` without password).
   #   `IP` with the ip of the target machine.
   sudo nix --experimental-features "nix-command flakes" \
     run github:nix-community/nixos-anywhere -- \
     --flake ".#<NIXOS-CONFIGURATION-NAME>" \
     --generate-hardware-config nixos-facter ./machines/<MACHINE-NAME>/facter.json \
     --target-host <USER>@<IP> \
     --show-trace
   ```

For more information see [nixos-anywhere](https://nix-community.github.io/nixos-anywhere) and [disko](https://github.com/nix-community/disko).

