# NixOS manual installation

The process is fully detailed in the [Installation](https://nixos.org/manual/nixos/stable/#ch-installation) section of the NixOS manual.


## Concepts
-----------

### Motherboard firmware

Software stored in the motherboard itself. You make the choice when you buy the hardware.

Two options; UEFI and BIOS (legacy).

If `/sys/firmware/efi` exists, the firmware is UEFI, otherwise it is BIOS.

### Partitions

Partition table is data at the start (sometimes also at the end) of a disk describing partitions (their locations, sizes, types, etc.).

Two options; GPT or MBR.

  - UEFI → GPT
    UEFI looks for an EFI System Partition (`ESP`) to boot. This partition type is supported by the GUID Partition Table (GPT).

  - BIOS → MBR
    Legacy BIOS boots by looking at the very first sectors of the disk, called the Master Boot Record (MBR). Can also boot from a disk using GPT with the right setup.

Partitions are virtual divisions on a single physical disk appearing as multiple independent drives. The number and type of partitions depend on:

  - Motherboard firmware
  - Filesystems to be used
  - Whether encryption is required
  - Whether a swap partition is required

Each partition has a filesystem — the internal structure used to write/retrieve data.

#### Wipe data

Creating a new partition table and filesystems does not override previous data, which sometimes can cause errors (the new partition table did not override all sectors used by the previous one or one of the new partitions may be using the same sectors of a previous partition).

When reusing a disk always do one of the following:

  - Override all previous data with random data (`dd if=/dev/urandom of=/dev/sdX bs=4M status=progress`) — most secure and reliable but very slow, overkill for personal use devices.

  - Delete each partition filesystem (`wipefs -a /dev/sdXY`) and then the partition table (`wipefs -a /dev/sdX`) itself.

To verify, first inform the OS about the changes (`partprove /dev/sdX`) and then review with `lsblk -l /dev/sdX`.

### Filesystem

System used by the partition to store and retrieve data.

The filesystem is created in the actual partition — the tags you may see in the partition table are only hints to the operating system (ignored by Linux).

Btrfs seem to be the future. Its subvolumes seem to be a much better approach than normal partitions.


## Instructions
---------------

Login as root (`sudo -i`), change its password (`passwd`) and ssh into the machine (`ssh root@<IP>`), that way you can copy/paste most commands from this document.

Identify the target disk with `lsblk -f` and use it in place of `sdX` in the example commands.

### Recommended settings for BIOS systems

Two partitions — a tiny one at the start for the BIOS bootloader (must not be encrypted), and a second one filling the rest of the drive for our encrypted system (inside it btrfs subvolumes for `/` and `/home`, and (optionally) a swap file).

1. Partition the disk

  ```sh
  # Remove previous filesystems from all previous partitions (recommended)
  `wipefs -a /dev/sdXN`

  # Remove the previous partition table
  `wipefs -a /dev/sdX`

  # Create a GPT partition table on the disk
  parted -s /dev/sdX mklabel gpt

  # Create the BIOS boot partition (1MB)
  parted -s /dev/sdX mkpart primary 1MiB 2MiB
  # Mark it specifically as a BIOS boot partition
  parted -s /dev/sdX set 1 bios_grub on
  # Delete any previous si

  # Create the main partition using the rest of the disk
  parted -s /dev/sdX mkpart primary 2MiB 100%

  # Inform the system about changes (to verify)
  partprobe /dev/sdX

  # Review
  parted --list
  ```

2. Set Up LUKS Encryption

  Initialize the encryption container on the main partition, maps to `/dev/mapper/cryptroot`.

  ```sh
  # Format the partition with LUKS (you will be prompted to create a password)
  cryptsetup luksFormat /dev/sdX2

  # Open the encrypted partition
  cryptsetup open /dev/sdX2 cryptroot
  ```

3. Create the Filesystem & Subvolumes

  Instead of making separate partitions for Swap and Home, Btrfs allows us to handle everything inside one layout. We will format the unlocked layout, create our subvolumes, and then mount them cleanly.

  ```sh
  # Format the unlocked container with Btrfs
  mkfs.btrfs -L system /dev/mapper/cryptroot

  # Mount the root Btrfs filesystem temporarily to create subvolumes
  mount /dev/mapper/cryptroot /mnt

  # Create the subvolumes for root and home
  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home

  # Unmount the temporary root mapping
  umount /mnt
  ```

4. Mount Subvolumes & Activate Swap

  With the subvolumes created, we mount them to their final destinations. Btrfs supports swap files directly, which is the cleanest approach when using subvolumes.

  ```sh
  # Mount the root subvolume (@) to /mnt
  mount -o noatime,compress=zstd,subvol=@ /dev/mapper/cryptroot /mnt

  # Create target directories for home and swap
  mkdir -p /mnt/home
  mkdir -p /mnt/swap

  # Mount the home subvolume (@home) to /mnt/home
  mount -o noatime,compress=zstd,subvol=@home /dev/mapper/cryptroot /mnt/home

  # Mount the flat root Btrfs layout to /mnt/swap to host the swapfile safely
  mount -o noatime,subvol=/ /dev/mapper/cryptroot /mnt/swap

  # Allocate a 8GB Btrfs swapfile
  btrfs filesystem mkswapfile --size 8g /mnt/swap/swapfile

  # Activate the swapfile
  swapon /mnt/swap/swapfile
  ```

5. Install NixOS:

  ```sh
  # Generate default configuration files
  nixos-generate-config --root /mnt

  # Install neovim (temporarily)
  nix --extra-experimental-features "nix-command flakes" shell "nixpkgs#neovim"

  # Open the main configuration file and copy the base configuration `./installation-base.nix`
  nvim /mnt/etc/nixos/configuration.nix

  # Do the installation (will ask for root password at the end)
  nixos-install

  # Set the user password (replace user)
  nixos-enter --root /mnt -c 'passwd <USER>'

  # Reboot
  reboot
  ```
