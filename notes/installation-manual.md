# NixOS manual installation

> TO BE REVIEWED!

For official documentation, see [Installation](https://nixos.org/manual/nixos/stable/#ch-installation).

## Notes

- Why a swap file instead of a swap partition?
  A swap file is much more flexible than a partition and only marginally slower.
  You can resize or remove it later without the risk of damaging the system.
  Ask AI for more information.

- Why not a graphical installer?
  The graphical installer does not allow to assign labels to partitions or file systems. Labels are required to make the hardware-configuration files reusable between installations.


## ISO

- Download the minimal ISO image from [nixos.org/download/](https://nixos.org/download).

- Create a bootable USB:

  `sudo dd bs=4M conv=fsync oflag=direct status=progress if=<path-to-image> of=/dev/<disk>` - change `if` and `of` to proper values.

- Boot from the USB:

  On devices with very old Nvidia graphic cards you may need to enable the `copytoram` and `nomodeset` options - press `e` over the desired option in order to edit it and then press `F10` to load the installer.


## Internet

- Check internet connection:

  `ping google.com`

  See [networking in the installer](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking) for detailed instructions.

- Log in as root:

  `sudo -i`

  Most of the following commands will require sudo privileges.

- Optionally, continue over ssh so that you can copy/paste all the following commands.

  Use `passwd` to change current user's password.
  Use `ip a` to check the IP address.

  Then use `ssh root@<ip>` to login from a remote machine.


## Firmware

- Check the firmware interface:

  `ls /sys/firmware/efi` - only returns any output for UEFI systems.

  > IMPORTANT! All following commands apply to UEFI systems only. For BIOS instructions see [Legacy Boot (MBR)](https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning-MBR).


## Disk partitions

- Identify the target disk:

  Execute `lsblk -f` and recognize the disk where you want to install NixOS.

  Replace `<disk>` with the proper disk identifier in the following commands.

- Create a new GPT table:

  `parted /dev/<disk> -- mklabel gpt`

- Create partitions:

  1. `parted /dev/<disk> -- mkpart ESP fat32 1MB 512MB`

     `ESP` is the partition label and it stands for "EFI System Partition".

  2. `parted /dev/<disk> -- mkpart root ext4 512MB 100%`

     `root` is the partition label and it is used in the hardware configuration file.

- Set the EFI System Partition flag for the first partition:

  `parted /dev/<disk> -- set 1 esp on` - makes the first partition recognizable for booting on UEFI systems.

- Check the results:

  `parted --list`

- Encrypt the root partition:

  `cryptsetup luksFormat /dev/<disk>2` - enter a password when prompted.

- Open the encrypted partition:

  `cryptsetup luksOpen /dev/<disk>2 crypted`

  Here, `crypted` is just a name, in principle you could use whatever you want but do not change it since this name is also used in the hardware-configuration file.


## Create the file systems

- Create the file system for the boot partition:

  `mkfs.fat -F 32 -n boot /dev/<disk>1`

  Here, `boot` is the file system label that is also being used in the hardware-configuration file.

- Create the file system for the encrypted partition:

  `mkfs.ext4 -L nixos /dev/mapper/crypted`

  Again, `nixos` is the file system label that is also being used in the hardware-configuration file.


## Mounting

- Mount the root file system:

  `mount /dev/disk/by-label/nixos /mnt`

- Mount the boot file system:

  `mkdir -p /mnt/boot` - create a directory inside `/mnt`.

  `mount -o umask=077 /dev/disk/by-label/boot /mnt/boot` - mount the file system, making its contents accessible only to `root`.


## Configuration files

- Generate NixOS configuration files:

  `nixos-generate-config --root /mnt`

- Edit `configuration.nix`:

  `nano /mnt/etc/nixos/configuration.nix`

  Just the basic stuff, everything will be replaced later with our flake:

  - Enable internet connection:
    Uncomment `networking.networkmanager.enable = true;`.

  - Set the correct time zome:
    Uncomment `time.timeZone` and change its value to `America/Guayaquil`.

  - Set the user account:
    - Uncomment the `users.users` attribute set.
    - Change the username.
    - Add `networkmanager` to the `extraGroups` option list.
    - Add `neovim` and `git` to the packages list (`git` is required by Flakes).

  - Enable openssh:
    Uncomment `services.openssh.enable = true;`.

  - Allow non-free packages:
    Add `nixpkgs.config.allowUnfree = true;`.

  - Enable the new nix cli and flakes — [more info](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled):
    Add `nix.settings.experimental-features = [ "nix-command" "flakes" ];`.

- Edit `hardware-configuration.nix`:

  `nano /mnt/etc/nixos/hardware-configuration.nix`

  Replace disks' UUIDs with partition and file system labels to make this file reusable accross installations:

    - `/` (filesystem) -> `/dev/disk/by-label/nixos`
      `nixos` is the label for the file system in the root partition.

    - `crypted` (device) -> `/dev/disk/by-partlabel/root`
      `root` is the partition label for the root partition.

    - `/boot` (filesystem) -> `/dev/disk/by-label/boot`
      `boot` is the label for the filesystem in the boot partition.


## Install

- Install NixOS:

  `nixos-install`

  When prompted, enter the root user's password.

- Change the user password:

  `nixos-enter --root /mnt -c 'passwd {USER}'`

  Use the same username as the one you set up in the configuration file.

- Reboot:

  `reboot`

