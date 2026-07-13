# NixOS git analogy

NixOS fundamentally treats the entire operating system configuration like a Git repository, viewing the entire filesystem as a declarative "checkout" rather than a mutable pile of files.

1. The `/nix/store` is just like the `.git/objects/` database.

   Just like git objects, Nix Store elements are immutable.

   Just as Git creates a new object (with a new hash) when anything changes in a file, Nix creates a new path in the `/nix/store` with a new hash when a single dependency or configuration line is altered.

2. System generations are just like Git commits.

   Every time you do a `nixos-rebuild`, you are essentially "committing" a new system generation. It is a complete, immutable snapshot of your system state.

   > NOTE: Check all system generations in `/nix/var/nix/profiles`.

   `/run/current-system` is a symlink to the current system generation.
   `/etc/profiles/per-user/<USER>` is a symlink to the current user profile.

   Nix Store objects are kept until you decide to delete the old generations. Elements that are not referenced by any generation are garbage-collected.

3. The FHS resembles a git working directory.

   Directories like `/etc` or `/run/current-system` are not filled with actual files; they are a working directory tree composed of symlinks pointing directly into the immutable `/nix/store`.

4. `nixos-rebuild --rollback` is just like `git checkout <hash>`.

   Rolling back to a previous system state at boot or via the CLI doesn't uninstall or reinstall anything. It instantly flips the root symlinks to point back to an older, intact store generation.

5. `sudo nix-collect-garbage -d` is just like doing a `git gc`.

   Unused packages and old configurations are safely left isolated in the store until you explicitly run the garbage collector to prune orphaned objects.
