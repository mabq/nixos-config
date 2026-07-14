# Guidelines

Nix is all about **declarative and reproducible** configurations. Do not obfuscate things by trying to mimic imperative practices.

Most configuration files should be symlinks to this repository (`mkOutOfStoreSymlink`) to avoid unnecessary rebuilds. Push those changes if you want to reproduce them later.
