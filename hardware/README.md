# Hardware files

Each hardware file belongs to a single machine.

Name hardware files in the following manner:

  `<hardware-model[.instance].date>.nix`

For example:

  `GB-BXi3-5010.1.260713`

Why?

1. The hardware model allows to identify which machine the file belongs to.

   E.g. `GB-BXi3-5010` (Gigabyte Brix).

2. The instance (optional) allows to identify an instance of the same model.

   Like in data centers where you deploy different configurations to the same instance model.

   Optional because most of the time it won't be needed.

   E.g. `1` (First instance).

3. The date allows to quickly identify when the file was created.

   Its important to understand that the same machine will produce different hardware files at different times. For example:

     - When you do a reinstall disk UUIDs will change (formatting).
     - `system.stateVersion` will also change if you use a newer version of NixOS.
     - Parts could be replaced (disk, GPU, memory).

    E.g. `260713` (July 13, 2026).
